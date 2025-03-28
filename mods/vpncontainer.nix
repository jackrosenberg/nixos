{ config, lib, pkgs, ... }:
{
  environment.etc.openvpn.source = "${pkgs.update-resolv-conf}/libexec/openvpn";
  services.openvpn.servers = {
    torrentvpn = {
      config = ''
        config /etc/nixos/openvpn/nl-01.protonvpn.udp.ovpn
        auth-user-pass /etc/nixos/openvpn/auth-user-pass
      ''; 
      # updateResolvConf = true; needs to be off otherwise tailscale fucks up
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

  # syncusers and groups
  users = {
  #   extraUsers = {
  #     sonarr = {
  #       uid = 274;
  #       home  = "/var/lib/sonarr";
  #       group = "media";
  #     };
  #     radarr = {
  #       uid = 275;
  #       home  = "/var/lib/radarr";
  #       group = "media";
  #     };
  #     transmission = {
  #       uid = 70;
  #       home  = "/var/lib/transmission";
  #       group = "media";
  #     };
  #   };
  };


  containers.vpn = {
    autoStart = true;
  
    privateNetwork = true; # needed for vpn 
    hostAddress = "192.168.100.10";
    localAddress = "192.168.100.11";
    
    # privateUsers = "pick";
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
          package = pkgs.transmission_4;
          settings = {
            # home = "/home/media";
            download-dir = "/home/media/downloads";
            # incomplete-dir = "/home/media/incomplete";
            rpc-bind-address = "0.0.0.0";
          };
        };
        prowlarr = {
          enable = true;
          openFirewall = true;
        };
        # flaresolverr = {
        #   enable = true;
        #   package = nur.repos.xddxdd.flaresolverr-21hsmw;
        #   openFirewall = true;
        # };
         radarr = {
            enable = true;
            openFirewall = true;
          };
         sonarr = {
            # dataDir = "/home/media/downloads";
            enable = true;
            # group = "media";
            openFirewall = true;
        };
      };
      # add a group that can edit the folder "/var/lib/nixos-containers/vpn/home/media"
      users.groups.media.members = [ "vpnuser" "radarr" "sonarr" "transmission" ];

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

      users.extraUsers.vpnuser = {
        isNormalUser = true;
        uid = 1000;
      };
    };
  };
}
