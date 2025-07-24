{ pkgs, lib, ... }:
let
  genPaths = loc:
    lib.concatMapAttrs (name: values:
      builtins.listToAttrs (map (value:
        lib.nameValuePair "${loc}/${value}" {
          Z = {
            user = name;
            group = "media";
            mode = "0770";
          };
        }) values));

  commonPaths = {
    "sonarr" = [ "shows" ];
    "radarr" = [ "movies" ];
    "readarr" = [ "books/ebooks" "books/audiobooks" ];
  };
in {
  environment.etc.openvpn.source = "${pkgs.update-resolv-conf}/libexec/openvpn";

  # setup service on host to run VPN
  # cant be via wg, since that fucks with tailscale
  services.openvpn.servers.torrentvpn.config = ''
    config /etc/nixos/openvpn/nl-01.protonvpn.udp.ovpn
    auth-user-pass /etc/nixos/openvpn/auth-user-pass
  '';

  networking = {
    nat = {
      enable = true;
      internalInterfaces = [ "ve-+" ];
      externalInterface = "tun0";
    };
    networkmanager.unmanaged = [ "interface-name:ve-*" ];
  };
  # make the paths required in the host for media
  systemd.tmpfiles.settings."10-media-paths" =
    (genPaths "/mnt/media" commonPaths) // 
    {
      "/mnt/media".d = {
        user = "root";
        group = "media";
        mode = "0770";
      };
    };
  # remake users
  users = {
    groups.media = {
      gid = lib.mkForce 999;
      members = [
        "jellyfin"
        "prowlarr"
        "radarr"
        "sonarr"
        "bazarr"
        "readarr"
        "audiobookshelf"
        "transmission"
      ];
    };
    users = builtins.mapAttrs (name: value: {
      group = "media";
      uid = lib.mkForce value;
    }) {
      "transmission" = 70;
      "sonarr" = 274;
      "radarr" = 275;
      "prowlarr" = 995;
      "readarr" = 997;
      "bazarr" = 999;
    };
  };

  containers.pirateship = {
    autoStart = true;
    privateNetwork = true; # needed for vpn
    hostAddress = "192.168.100.10";
    localAddress = "192.168.100.11";

    bindMounts."/home/media" = { # path in container
      hostPath = "/mnt/media"; # path in host
      isReadOnly = false; # allow container to write to outside container here
    };

    config = { lib, pkgs, ... }: {
      environment = {
        systemPackages = with pkgs; [ kitty neovim fastfetch ];
        # only allow access to proton's nameservers so no DNSleaks
        etc."resolv.conf".text = ''
          nameserver 10.96.0.1
        '';
      };

      networking = {
        # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
        useHostResolvConf = lib.mkForce false;

        firewall = {
          enable = true;
          allowedTCPPorts = [ 80 ];
        };
      };

      # add users to correct group in container
      users.groups.media.members =
        [ "prowlarr" "radarr" "sonarr" "bazarr" "readarr" "transmission" ];
      systemd = {
        # stupid ass fix for transmission
        services.transmission.serviceConfig = {
          RootDirectoryStartOnly = lib.mkForce false;
          RootDirectory = lib.mkForce "";
          BindReadOnlyPaths = lib.mkForce [ builtins.storeDir "/etc" ];
        };
        # remake paths in container as transmission & co expect
        tmpfiles.settings."10-media-paths" = genPaths "/home/media"
          (commonPaths // { "transmission" = [ "downloads" ".incomplete" ]; });
      };
      services = {
        transmission = {
          enable = true;
          group = "media";
          openFirewall = true;
          openRPCPort = true;
          package = pkgs.transmission_4;
          # grosshack, needs to be made manually :(
          credentialsFile = "/var/lib/secrets/trans.json";
          # extraFlags = [ "--log-debug" ];
          settings = {
            download-dir = "/home/media/downloads";
            incomplete-dir = "/home/media/.incomplete";
            rpc-bind-address = "0.0.0.0";
            rpc-whitelist = "127.0.0.1,192.168.100.10";
            rpc-host-whitelist = "*.jackr.eu,*.spectrumtijger.nl";
            rpc-authentication-required = true;
          };
        };
        prowlarr = {
          openFirewall = true;
          enable = true;
        };
        flaresolverr = {
          enable = true;
          openFirewall = true;
        };
        bazarr = {
          enable = true;
          openFirewall = true;
          group = "media";
        };
        radarr = {
          enable = true;
          openFirewall = true;
          group = "media";
        };
        sonarr = {
          enable = true;
          openFirewall = true;
          group = "media";
        };
        readarr = {
          enable = true;
          openFirewall = true;
          group = "media";
        };
      };
    };
  };
}
