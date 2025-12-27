{
  config,
  pkgs,
  lib,
  ...
}:
### general idea:
### torrent in container to .incomplete -> downloads
### individual services take torrent and move it to
### their own folders (/home/media/{shows,movies,books})
### transmission only lives within the container,
### bindMounts ensure that media is available outside

let
  genPaths =
    loc:
    lib.concatMapAttrs (
      name: values:
      builtins.listToAttrs (
        map (
          value:
          lib.nameValuePair "${loc}/${value}" {
            # create
            d = {
              user = name;
              group = "media";
              mode = "0770";
            };
          }
        ) values
      )
    );

  commonPaths = {
    "sonarr" = [ "shows" ];
    "radarr" = [ "movies" ];
    "readarr" = [
      "books/ebooks"
      "books/audiobooks"
    ];
  };
  common = {
    enable = true;
    openFirewall = true;
  };
in
{
  # agenix
  age = {
    secrets."vpn.ovpn".file = ../secrets/vpn.ovpn.age;
    secrets.vpn-auth-user-pass.file = ../secrets/vpn-auth-user-pass.age;
    identityPaths = [ "/etc/age/id_ed25519" ];
  };

  # setup service on host to run VPN
  # cant be via wg, since that fucks with tailscale
  # https://protonvpn.com/support/linux-openvpn/
  environment.etc.openvpn.source = "${pkgs.update-resolv-conf}/libexec/openvpn";
  services.openvpn.servers.torrentvpn.config = ''
    config ${config.age.secrets."vpn.ovpn".path}
    auth-user-pass ${config.age.secrets.vpn-auth-user-pass.path}
  '';

  networking = {
    nat = {
      enable = true;
      internalInterfaces = [ "ve-+" ];
      externalInterface = "tun0";
    };
    networkmanager.unmanaged = [ "interface-name:ve-*" ];
  };
  systemd = {
    services = {
      fix-perms = {
        serviceConfig.ExecStart = "${lib.getExe' pkgs.coreutils "chmod"} -R 770 /mnt/media";
        startAt = "hourly";
      };
    };
    # make the paths required in the host for media
    tmpfiles.settings."10-media-paths" = (genPaths "/mnt/media" commonPaths) // {
      "/mnt/media".d = {
        user = "root";
        group = "media";
        mode = "0770";
      };
    };
  };
  # remake users
  users = {
    groups.media = {
      gid = 999;
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
    users =
      builtins.mapAttrs
        (name: value: {
          group = "media";
          uid = lib.mkForce value;
        })
        {
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

    bindMounts."/home/media" = {
      # path in container
      hostPath = "/mnt/media"; # path in host
      isReadOnly = false; # allow container to write to outside container here
    };

    config =
      { lib, pkgs, ... }:
      {
        environment = {
          systemPackages = with pkgs; [
            kitty
            neovim
            fastfetch
          ];
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
        users.groups.media.members = [
          "prowlarr"
          "radarr"
          "sonarr"
          "bazarr"
          "readarr"
          "transmission"
        ];
        systemd = {
          # make paths in container as transmission & co expect
          tmpfiles.settings."10-media-cont-paths" = genPaths "/var/lib/transmission" {
            "transmission" = [
              ".incomplete"
              "Downloads/tv-sonarr"
              "Downloads/radarr"
              "Downloads/books/ebooks"
              "Downloads/books/audiobooks"
            ];
          };
          # stupid ass fix for transmission
          services.transmission.serviceConfig = {
            ## following 3 lines are needed to make transmission work in a container
            # https://github.com/NixOS/nixpkgs/issues/258793
            RootDirectoryStartOnly = lib.mkForce false;
            RootDirectory = lib.mkForce "";
            BindReadOnlyPaths = lib.mkForce [
              builtins.storeDir
              "/etc"
            ];
            ##
            # allow transmission to see this
            BindPaths = [ /home/media ];
            # can be removed after PR goes tru
            UMask = lib.mkForce 007;
            # since otherwise the downloadDirPermissions does nothing
            StateDirectoryMode = 770;
          };
        };
        system.activationScripts.transmission-daemon = lib.mkForce "";
        services = {
          transmission = common // {
            group = "media";
            openRPCPort = true;
            package = pkgs.transmission_4;
            # grosshack, needs to be made manually :(
            credentialsFile = "/var/lib/secrets/trans.json";
            extraFlags = [ "--log-level=error" ];
            # allow media to rwx
            downloadDirPermissions = "770";
            settings = {
              # all new files are 770
              ## currently PR'd
              umask = 007;

              # script-torrent-done-filename !!!!!!!!!!!!!!!!!!!!!
              rpc-bind-address = "0.0.0.0";
              rpc-whitelist = "127.0.0.1,192.168.100.10";
              rpc-host-whitelist = "*.jackr.eu,*.spectrumtijger.nl";
              rpc-authentication-required = true;
            };
          };
          prowlarr = common;
          flaresolverr = common;
          bazarr = common // {
            group = "media";
          };
          radarr = common // {
            group = "media";
          };
          sonarr = common // {
            group = "media";
          };
          readarr = common // {
            group = "media";
          };
        };
      };
  };
}
