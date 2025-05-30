{ pkgs, ... }:
{
  environment.etc.openvpn.source = "${pkgs.update-resolv-conf}/libexec/openvpn";

  services = {
    openvpn.servers = {
      torrentvpn = {
        config = ''
          config /etc/nixos/openvpn/nl-01.protonvpn.udp.ovpn
          auth-user-pass /etc/nixos/openvpn/auth-user-pass
        ''; 
        # updateResolvConf = true; needs to be off otherwise tailscale fucks up
      };
    };
  };

  networking = {
    nat = {
      enable = true;
      internalInterfaces = ["ve-+"];
      externalInterface = "tun0";
    };
    networkmanager.unmanaged = [ "interface-name:ve-*" ];
  };
  systemd.tmpfiles.rules = [
      "Z /mnt/media/shows 771 sonarr media"
      "Z /mnt/media/movies 771 radarr media"
  ];

  # remake users
  users = {
    groups.media = {
      gid = 1000;
      members = ["jellyfin" "prowlarr" "radarr" "sonarr" "bazarr" "readarr"];
    };
    users = {
     "sonarr" = {
        group = "media";
        uid = 274;
      };
      "radarr" = {
        group = "media";
        uid = 275;
      };
      "prowlarr" = {
        uid = 995;
        group = "media";
      };
     "readarr" = {
        group = "media";
        uid = 996;
      };
     "bazarr" = {
        group = "media";
        uid = 997;
      };
    };
  };

  containers.pirateship = {
    autoStart = true;
  
    privateNetwork = true; # needed for vpn 
    hostAddress = "192.168.100.10";
    localAddress = "192.168.100.11";
    
    bindMounts."/home/media" = { # path in container
      hostPath = "/mnt/media"; # path in host
      isReadOnly = false;
    };

    config = { lib, pkgs, ... }: 
    {
      environment.systemPackages = with pkgs; [
        kitty
        neovim
        fastfetch
      ];

     environment.etc = { # grosshack
        "resolv.conf".text = "nameserver 10.96.0.1\n";
      };

      networking = {
        # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
        useHostResolvConf = lib.mkForce false;

        firewall = {
          enable = true;
          allowedTCPPorts = [ 80 ];
        };
      };

      # add users to correct group
      users.groups.media.members = ["prowlarr" "radarr" "sonarr" "bazarr" "readarr" "transmission"];

      systemd = {
        # stupid ass fix for transmission
        services.transmission.serviceConfig = {
          RootDirectoryStartOnly = lib.mkForce false;
          RootDirectory = lib.mkForce "";
          BindReadOnlyPaths = lib.mkForce [ builtins.storeDir "/etc" ];
        };
        # recursive chown of folders so bazarr can write subs
        tmpfiles.rules = [
            "Z /home/media/shows 771 sonarr media"
            "Z /home/media/movies 771 radarr media"
        ];
      };
      services = {
        transmission = {
          enable = true;
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
            rpc-whitelist =  "127.0.0.1,192.168.100.10";
            rpc-host-whitelist =  "*.jackr.eu";
            rpc-authentication-required = true;
          };
        };
        prowlarr = {
          enable = true;
          # group = "media";
          openFirewall = true;
        };
        # flaresolverr = {
        #   enable = true;
        #   package = config.inputs.nur.repos.xddxdd.flaresolverr-21hsmw;
        #   openFirewall = true;
        # };
        bazarr = {
          enable = true;
          group = "media";
          openFirewall = true;
        };
        radarr = {
          enable = true;
          group = "media";
          openFirewall = true;
         };
        sonarr = {
          enable = true;
          group = "media";
          openFirewall = true;
        }; 
        readarr = {
          enable = true;
          group = "media";
          openFirewall = true;
        }; 
      };
    };
  };
}
