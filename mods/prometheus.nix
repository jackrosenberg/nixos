{...}:
{
services.prometheus = {
  enable = true;
  port = 9001;
  globalConfig.scrape_interval = "15s";

  exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9002;
      };
      zfs = {
        enable = true;
        pools = ["nixpool"];
        port = 9012;
      };
      influxdb = {
        enable = true;
        port = 9122;
      };
  };

  scrapeConfigs = [
      {
        job_name = "node";
        static_configs = [{
          targets = [ "127.0.0.1:9002" ];
        }];
      }
      {
        job_name = "zfs";
        static_configs = [{
          targets = [ "127.0.0.1:9012" ];
        }];
      }
      {
        job_name = "influxdb";
        static_configs = [{
          targets = [ "127.0.0.1:9122" ];
        }];
      }
  ];

};
}
