{ config, pkgs, ...}:
# let port = 3013;
# in
{
#   services = { 
#     outline = {
#       enable = true;
#       inherit port;
#       publicUrl = "https://wiki.spectrumtijger.nl";
#       forceHttps = false;
#       storage.storageType = "local";
#       oidcAuthentication = {
#           # Parts taken from
#           # http://dex.localhost/.well-known/openid-configuration
#           authUrl = "http://dex.localhost/auth";
#           tokenUrl = "http://dex.localhost/token";
#           userinfoUrl = "http://dex.localhost/userinfo";
#           clientId = "outline";
#           clientSecretFile = (builtins.elemAt config.services.dex.settings.staticClients 0).secretFile;
#           scopes = [ "openid" "email" "profile" ];
#           usernameClaim = "preferred_username";
#           displayName = "Dex";
#         };
#       };
#
#     dex = {
#       enable = true;
#       settings = {
#         issuer = "http://dex.localhost";
#         storage.type = "sqlite3";
#         web.http = "127.0.0.1:5556";
#         enablePasswordDB = true;
#         staticClients = [
#           {
#             id = "outline";
#             name = "Outline Client";
#             redirectURIs = [ "http://localhost:${port}/auth/oidc.callback" ];
#             secretFile = "${pkgs.writeText "outline-oidc-secret" "test123"}";
#           }
#         ];
#         staticPasswords = [
#           {
#             email = "user.email@example.com";
#             # bcrypt hash of the string "password": $(echo password | htpasswd -BinC 10 admin | cut -d: -f2)
#             hash = "10$TDh68T5XUK10$TDh68T5XUK10$TDh68T5XUK";
#             username = "test";
#             # easily generated with `$ uuidgen`
#             userID = "6D196B03-8A28-4D6E-B849-9298168CBA34";
#           }
#         ];
#       };
#     };
#   };
}
