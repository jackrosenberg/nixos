{ config, pkgs, ... }:
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

  # remake users
  users.groups.media = {
    gid = 1000;
    members = ["prowlarr" "radarr" "sonarr" "bazarr" "readarr"];
  };
  users.extraUsers = {
   "sonarr" = {
      group = "media";
      uid = 274;
    };
    "radarr" = {
      group = "media";
      uid = 275;
    };
    "prowlarr" = {
      group = "media";
      uid = 995;
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

  containers.vpn = {
    autoStart = true;
  
    privateNetwork = true; # needed for vpn 
    hostAddress = "192.168.100.10";
    localAddress = "192.168.100.11";
    
    bindMounts = {
      "/home/media" = { # path in container
        hostPath = "/mnt/media"; # path in host
        isReadOnly = false;
      };
    };

    config = { config, lib, pkgs, ... }: 
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

      # stupid ass fix for transmission
      systemd.services.transmission.serviceConfig = {
        RootDirectoryStartOnly = lib.mkForce false;
        RootDirectory = lib.mkForce "";
        BindReadOnlyPaths = lib.mkForce [ builtins.storeDir "/etc" ];
      };
      services = {
        transmission = {
          enable = true;
          openFirewall = true;
          openRPCPort = true;
          package = pkgs.transmission_4;
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
          openFirewall = true;
        };
        # flaresolverr = {
        #   enable = true;
        #   package = config.inputs.nur.repos.xddxdd.flaresolverr-21hsmw;
        #   openFirewall = true;
        # };
        bazarr = {
          enable = true;
          openFirewall = true;
        };
        radarr = {
          enable = true;
          openFirewall = true;
         };
        sonarr = {
          enable = true;
          openFirewall = true;
        }; 
        readarr = {
          enable = true;
          openFirewall = true;
        }; 
      };
    };
  };
}
