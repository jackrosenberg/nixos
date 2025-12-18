{ ... }:
{
  # up the mem so that the elliptical curve works
  boot.kernel.sysctl = {
    "net.core.rmem_max" = 7500000;
    "net.core.wmem_max" = 7500000;
  };
  # i love the lack of documentation
  services.cloudflared = {
    enable = true;
    tunnels = {
      "f084a5e7-f056-4de8-9c6d-8817444efba4" = {
        credentialsFile = "/var/lib/cloudflared/f084a5e7-f056-4de8-9c6d-8817444efba4.json";
        default = "http_status:404";
      };
    };
  };
}
