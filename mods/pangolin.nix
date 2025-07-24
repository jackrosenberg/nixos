{ config, pkgs, ... }: {
  services.pangolin = {
    enable = true;
    # package = pkgs.fosrl-pangolin.overrideAttrs (_: {
    #   # patches = [
    #   #   ./0001-no-phone-home.patch
    #   #   ./0002-license-override.patch
    #   # ];
    # });
    settings = {
      # domains.default = {
      domains.domain1 = { prefer_wildcard_cert = true; };
    };
    dnsProvider = "mijnhost";
    baseDomain = "spectrumtijger.nl";
    letsEncryptEmail = "pangolin@jackr.eu";
    openFirewall = true;
    pangolinEnvironmentFile = "/etc/nixos/secrets/pangolin.env";
    traefikEnvironmentFile = "/etc/nixos/secrets/traefik.env";
  };
}

