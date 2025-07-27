{ lib, ... }:
# stupid stupid nix-option fails on services.prometheus.exporters
let
  exporters = {
    node = {
      enable = true;
      enabledCollectors = [ "systemd" ];
      port = 9002;
    };
    zfs = {
      enable = true;
      pools = [ "nixpool" ];
      port = 9012;
    };
    influxdb = {
      enable = true;
      port = 9122;
    };
  };
in
{
  services.prometheus = {
    enable = true;
    port = 9001;
    globalConfig.scrape_interval = "15s";

    exporters = exporters;

    scrapeConfigs = lib.mapAttrsToList (name: value: {
      job_name = "${name}";
      static_configs = [ { targets = [ "127.0.0.1:${toString value.port}" ]; } ];
    }) exporters;
  };
}
