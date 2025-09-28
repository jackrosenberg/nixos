{ pkgs, modulesPath, ... }:
{
  boot.kernelPackages = pkgs.linuxPackages_latest;
  imports = [
    (modulesPath + "/virtualisation/digital-ocean-config.nix")
  ];

  # todo, modularize
  services.pangolin = {
    enable = true;
    settings = {
      domains.domain1 = {
        prefer_wildcard_cert = true;
      };
      flags = {
        disable_signup_without_invite = true;
        disable_user_create_org = true;
        enable_integration_api = true;
      };
    };
    dnsProvider = "mijnhost";
    baseDomain = "spectrumtijger.nl";
    letsEncryptEmail = "pangolin@jackr.eu";
    openFirewall = true;
    environmentFile = "/etc/nixos/secrets/pangolin.env";
  };
  services = {
    traefik.environmentFiles = [ "/etc/nixos/secrets/traefik.env" ];
  };

  environment.systemPackages = with pkgs; [
    fastfetch
    dysk
    xorg.xauth
    wireguard-tools
    sqlite
    jq
    shh
    fosrl-pangolin
    tree
  ];
}
