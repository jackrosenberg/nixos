{ config, pkgs, ... }:
let
  port = 3013;
in
{
  # networking.extraHosts = ''
  #   127.0.0.1 dex.localhost
  # '';
  #
  # age = {
  #   secrets.dexsecret = {
  #     file = ../secrets/dexsecret.age;
  #     owner = "outline";
  #     group = "outline";
  #   };
  #   identityPaths = [ "/etc/age/id_ed25519" ];
  # };
  #
  # services = {
  #   outline = {
  #     enable = true;
  #     inherit port;
  #     publicUrl = "https://wiki.spectrumtijger.nl";
  #     forceHttps = false;
  #     storage.storageType = "local";
  #     oidcAuthentication = {
  #         # Parts taken from
  #         # http://dex.localhost/.well-known/openid-configuration
  #         authUrl = "http://dex.localhost/auth";
  #         tokenUrl = "http://dex.localhost/token";
  #         userinfoUrl = "http://dex.localhost/userinfo";
  #         clientId = "outline";
  #         clientSecretFile = (builtins.elemAt config.services.dex.settings.staticClients 0).secretFile;
  #         scopes = [ "openid" "email" "profile" ];
  #         usernameClaim = "preferred_username";
  #         displayName = "Dex";
  #       };
  #     };
  #
  #   dex = {
  #     enable = true;
  #     settings = {
  #       issuer = "http://dex.localhost";
  #       storage.type = "sqlite3";
  #       web.http = "127.0.0.1:5556";
  #       enablePasswordDB = true;
  #       staticClients = [
  #         {
  #           id = "outline";
  #           name = "Outline Client";
  #           redirectURIs = [ "http://localhost:${toString port}/auth/oidc.callback" ];
  #           secretFile = config.age.secrets.dexsecret.path;
  #         }
  #       ];
  #       staticPasswords = [
  #         {
  #           email = "jack@jackr.eu";
  #           hash = "$2a$12$kz4VRUUfT0DU8PGQsr.uZOMaO2s5xsJLotp2AYl3NIOY1L6Ds3u56";
  #           username = "jack";
  #           # easily generated with `$ uuidgen`
  #           userID = "f09a5918-8524-4ee9-aac8-32f2fc0edd77";
  #         }
  #       ];
  #     };
  #   };
  #   nginx = {
  #     enable = true;
  #     virtualHosts = {
  #       "localhost" = {
  #         locations."/" = {
  #           proxyPass = "${config.services.outline.publicUrl}";
  #         };
  #       };
  #       "dex.localhost" = {
  #         locations."/" = {
  #           proxyPass = "http://${config.services.dex.settings.web.http}";
  #         };
  #       };
  #     };
  #   };
  # };
}
