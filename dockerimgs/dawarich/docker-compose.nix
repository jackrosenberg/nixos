# Auto-generated using compose2nix v0.3.2-pre.
{ pkgs, lib, config, ... }:

{
  # Runtime
  virtualisation.podman = {
    enable = true;
    autoPrune.enable = true;
    dockerCompat = true;
  };

  # Enable container name DNS for all Podman networks.
  networking.firewall.interfaces = let
    matchAll = if !config.networking.nftables.enable then "podman+" else "podman*";
  in {
    "${matchAll}".allowedUDPPorts = [ 53 ];
  };

  virtualisation.oci-containers.backend = "podman";

  # Containers
  virtualisation.oci-containers.containers."dawarich_app" = {
    image = "freikin/dawarich:latest";
    environment = {
      "APPLICATION_HOSTS" = "dawarich.jackr.eu";
      "APPLICATION_PROTOCOL" = "http";
      "DATABASE_HOST" = "dawarich_db";
      "DATABASE_NAME" = "dawarich_development";
      "DATABASE_PASSWORD" = "password";
      "DATABASE_USERNAME" = "postgres";
      "DISTANCE_UNIT" = "km";
      "ENABLE_TELEMETRY" = "false";
      "MIN_MINUTES_SPENT_IN_CITY" = "60";
      "PROMETHEUS_EXPORTER_ENABLED" = "false";
      "PROMETHEUS_EXPORTER_HOST" = "0.0.0.0";
      "PROMETHEUS_EXPORTER_PORT" = "9394";
      "RAILS_ENV" = "development";
      "REDIS_URL" = "redis://dawarich_redis:6379/0";
      "SELF_HOSTED" = "true";
      "TIME_ZONE" = "Europe/Amsterdam";
    };
    volumes = [
      "dawarich_dawarich_public:/var/app/public:rw"
      "dawarich_dawarich_storage:/var/app/storage:rw"
      "dawarich_dawarich_watched:/var/app/tmp/imports/watched:rw"
    ];
    ports = [
      "3000:3000/tcp"
    ];
    cmd = [ "bin/rails" "server" "-p" "3000" "-b" "::" ];
    dependsOn = [
      "dawarich_db"
      "dawarich_redis"
    ];
    log-driver = "journald";
    extraOptions = [
      "--cpus=0.5"
      "--entrypoint=[\"web-entrypoint.sh\"]"
      "--health-cmd=wget -qO - http://127.0.0.1:3000/api/v1/health | grep -q '\"status\"\\s*:\\s*\"ok\"'"
      "--health-interval=10s"
      "--health-retries=30"
      "--health-start-period=30s"
      "--health-timeout=10s"
      "--memory=4294967296b"
      "--network-alias=dawarich_app"
      # "--network=dawarich_dawarich"
    ];
  };
  virtualisation.oci-containers.containers."dawarich_db" = {
    image = "postgis/postgis:14-3.5-alpine";
    environment = {
      "POSTGRES_PASSWORD" = "password";
      "POSTGRES_USER" = "postgres";
    };
    volumes = [
      "dawarich_dawarich_db_data:/var/lib/postgresql/data:rw"
      "dawarich_dawarich_shared:/var/shared:rw"
    ];
    log-driver = "journald";
    extraOptions = [
      "--health-cmd=pg_isready -U postgres -d dawarich_development"
      "--health-interval=10s"
      "--health-retries=5"
      "--health-start-period=30s"
      "--health-timeout=10s"
      "--network-alias=dawarich_db"
      # "--network=dawarich_dawarich"
      "--shm-size=1073741824"
    ];
  };
  virtualisation.oci-containers.containers."dawarich_redis" = {
    image = "redis:7.0-alpine";
    volumes = [
      "dawarich_dawarich_shared:/data:rw"
    ];
    cmd = [ "redis-server" ];
    log-driver = "journald";
    extraOptions = [
      "--health-cmd=[\"redis-cli\", \"--raw\", \"incr\", \"ping\"]"
      "--health-interval=10s"
      "--health-retries=5"
      "--health-start-period=30s"
      "--health-timeout=10s"
      "--network-alias=dawarich_redis"
      # "--network=dawarich_dawarich"
    ];
  };
  virtualisation.oci-containers.containers."dawarich_sidekiq" = {
    image = "freikin/dawarich:latest";
    environment = {
      "APPLICATION_HOSTS" = "localhost";
      "APPLICATION_PROTOCOL" = "http";
      "BACKGROUND_PROCESSING_CONCURRENCY" = "10";
      "DATABASE_HOST" = "dawarich_db";
      "DATABASE_NAME" = "dawarich_development";
      "DATABASE_PASSWORD" = "password";
      "DATABASE_USERNAME" = "postgres";
      "DISTANCE_UNIT" = "km";
      "ENABLE_TELEMETRY" = "false";
      "PROMETHEUS_EXPORTER_ENABLED" = "false";
      "PROMETHEUS_EXPORTER_HOST" = "dawarich_app";
      "PROMETHEUS_EXPORTER_PORT" = "9394";
      "RAILS_ENV" = "development";
      "REDIS_URL" = "redis://dawarich_redis:6379/0";
      "SELF_HOSTED" = "true";
    };
    volumes = [
      "dawarich_dawarich_public:/var/app/public:rw"
      "dawarich_dawarich_storage:/var/app/storage:rw"
      "dawarich_dawarich_watched:/var/app/tmp/imports/watched:rw"
    ];
    cmd = [ "sidekiq" ];
    dependsOn = [
      "dawarich_app"
      "dawarich_db"
      "dawarich_redis"
    ];
    log-driver = "journald";
    extraOptions = [
      "--cpus=0.5"
      "--entrypoint=[\"sidekiq-entrypoint.sh\"]"
      "--health-cmd=bundle exec sidekiqmon processes | grep \${HOSTNAME}"
      "--health-interval=10s"
      "--health-retries=30"
      "--health-start-period=30s"
      "--health-timeout=10s"
      "--memory=4294967296b"
      "--network-alias=dawarich_sidekiq"
      # "--network=dawarich_dawarich"
    ];
  };
}
