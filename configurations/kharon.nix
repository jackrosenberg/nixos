{ pkgs, modulesPath, ... }:
{
  boot.kernelPackages = pkgs.linuxPackages_latest;
  imports = [
    (modulesPath + "/virtualisation/digital-ocean-config.nix")
    ../mods/ssh.nix
    # ../mods/shell.nix ../mods/home.nix
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
  services.traefik = {
    plugins = with pkgs; [ fosrl-badger geoblock ];
    # extra config needed for geoblock
    # staticConfigOptions.entryPoints.websecure.http.middlewares = "my-GeoBlock";
    dynamicConfigOptions = {
      http.middlewares.my-GeoBlock.plugin.geoblock = {
        silentStartUp = false;
        allowLocalRequests = true;
        logLocalRequests = false;
        logAllowedRequests = false;
        logApiRequests = false;
        api = "https://get.geojs.io/v1/ip/country/{ip}";
        apiTimeoutMs = 500;
        cacheSize = 25;
        forceMonthlyUpdate = true;
        allowUnknownCountries = false;
        unknownCountryApiResponse = "nil";
        countries = [ "NL" ];
      };
    };
    environmentFiles = [ "/etc/nixos/secrets/traefik.env" ]; 
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
  system.stateVersion = "25.11";
}
