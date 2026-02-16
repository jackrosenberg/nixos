{ config, ... }:
{
  age.secrets = {
    pangolin.rekeyFile = ../secrets/pangolin.age;
    traefik.rekeyFile = ../secrets/traefik.age;
  };

  services.pangolin = {
    enable = true;
    settings = {
      domains.domain1 = {
        prefer_wildcard_cert = true;
      };
      flags = {
        allow_raw_resources = true;
        disable_signup_without_invite = true;
        disable_user_create_org = true;
        enable_integration_api = true;
      };
    };

    dnsProvider = "mijnhost";
    baseDomain = "spectrumtijger.nl";
    letsEncryptEmail = "pangolin@jackr.eu";
    openFirewall = true;
    environmentFile = config.age.secrets.pangolin.path;
  };
  networking.firewall.allowedTCPPorts = [ 7777 ];

  services.traefik = {
    static.settings = {
      entryPoints.tcp-7777.address = ":7777/tcp";
    };
    # # geoblock
    # dynamicConfigOptions = {
    #   http.middlewares.my-GeoBlock.plugin.geoblock = {
    #     silentStartUp = false;
    #     allowLocalRequests = true;
    #     logLocalRequests = false;
    #     logAllowedRequests = false;
    #     logApiRequests = false;
    #     api = "https://get.geojs.io/v1/ip/country/{ip}";
    #     apiTimeoutMs = 500;
    #     cacheSize = 25;
    #     forceMonthlyUpdate = true;
    #     allowUnknownCountries = false;
    #     unknownCountryApiResponse = "nil";
    #     countries = [ "NL" "DE" ];
    #   };
    # };
    environmentFiles = [ config.age.secrets.traefik.path ];
  };
}
