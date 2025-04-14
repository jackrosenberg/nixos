{...}:
{
services.grafana = {
  enable = true;
  settings = {
    dashboards = {
      min_refresh_interval = "1s";
    };
    server = {
      # Listening Address
      http_addr = "0.0.0.0";
      # and Port
      http_port = 3069;
      # Grafana needs to know on which domain and URL it's running
      domain = "jackr.eu";
    };
  };
};
}
