
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

  containers.vpn = {
    autoStart = true;
  
    privateNetwork = true; # needed for vpn 
    hostAddress = "192.168.100.10";
    localAddress = "192.168.100.11";
    
    # bindMounts = {
    # "/etc/nixos/openvpn" = { # path in container
    #   hostPath = "/etc/nixos/openvpn"; # path in host
    #   isReadOnly = true;
    #   };
    # # jellyfin lib here
    # };

    config = { config, lib, pkgs, ... }: 
    {
      environment.systemPackages = with pkgs; [
        kitty
        neovim
        fastfetch
      ];

      services.prowlarr = {
        enable = true;
        openFirewall = true;
      };
      # services.flaresolverr = {
      #   # package = pkgs.nur.repos.xddxdd.flaresolverr-21hsmw; # fix for broken
      #   enable = true;
      #   openFirewall = true;
      # };
      # services.radarr = {
      #   enable = true;
      #   openFirewall = true;
      # };
      services.sonarr = {
        enable = true;
        openFirewall = true;
      };

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
