{ pkgs, lib, ... }:
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
  systemd = {
    # TODO change permissions, cant be asked rn
    tmpfiles.rules = [
      "Z /mnt/media/shows 770 sonarr media"
      "Z /mnt/media/movies 770 radarr media"
      "Z /mnt/media/books/{ebooks,audiobooks} 770 readarr media"
    ];
  };
  # remake users
  users = {
    groups.media = {
      gid = lib.mkForce 999;
      members = ["jellyfin" "prowlarr" "radarr" "sonarr" "bazarr" "readarr" "audiobookshelf" "transmission"];
    };
    users = {
     "transmission" = {
        group = "media";
        uid = lib.mkForce 70;
      };
     "sonarr" = {
        group = "media";
        uid = lib.mkForce 274;
      };
      "radarr" = {
        group = "media";
        uid = lib.mkForce 275;
      };
      "prowlarr" = {
        uid = lib.mkForce 995;
        group = "media";
      };
     "readarr" = {
        group = "media";
        uid = lib.mkForce 997;
      };
     "bazarr" = {
        group = "media";
        uid = lib.mkForce 999;
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
      environment = {
        systemPackages = with pkgs; [
          kitty
          neovim
          fastfetch
        ];
        etc."resolv.conf".text = "nameserver 10.96.0.1\n"; # grosshack
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
            "Z /home/media/{downloads,.incomplete} 770 transmission media"
            # folder for books since readarr sucks
            # does not work, need to make manually
            # mkdir -p /home/media/downloads/books/{ebooks,audiobooks}
            # chown -R transmission:media /home/media/downloads/books/
            # "Z /home/media/downloads/books 770 transmission media"
            "Z /home/media/shows 770 sonarr media"
            "Z /home/media/movies 770 radarr media"
            "Z /home/media/books 770 readarr media"
        ];
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
            rpc-whitelist =  "127.0.0.1,192.168.100.10";
            rpc-host-whitelist =  "*.jackr.eu,*.spectrumtijger.nl";
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
