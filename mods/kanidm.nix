{ lib, pkgs, ... }:
let
  inherit (lib)
    optional
    versionOlder
    ;

  domain = "auth.spectrumtijger.nl";
  package = pkgs.kanidm_1_6;
  kanidmDir = "/var/lib/kanidm";
in
{
  config = {
    services.kanidm = {
      enableServer = true;
      services.kanidm.package = package;
      serverSettings = {
        inherit domain;
        origin = "https://${domain}";
        tls_chain = "${kanidmDir}/secrets/fullchain.pem";
        tls_key = "${kanidmDir}/secrets/privkey.pem";
        bindaddress = "127.0.0.1:4000";
      };
    };
    warnings = optional (versionOlder package.version pkgs.kanidm.version) "A new Kanidm version is available. Please migrate from Kanidm ${package.version} to Kanidm ${pkgs.kanidm.version}.";
  };
  # TODO, add service to rsync the .pem's off of the remote server
}
