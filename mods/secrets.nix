{ pkgs, config, ... }:
{
  # secret management via yubikey
  # https://github.com/oddlama/agenix-rekey

  # generate keyspairs with: 
  # age-keygen -pq

  environment.systemPackages = with pkgs; [ age ];
  
  age.rekey = {
    storageMode = "local";
    masterIdentities = [ 
      "/etc/nixos/secrets/yubikey.pub"
      {
        identity = "/etc/nixos/secrets/identity.age";
        pubkey = "age1z5f9zy4qf4a2uns554wvlljs6dvxp5nev2fq07g732gnnr43my9qdnucu4";
      }
    ];
    # This cannot be shared with other hosts. Please refer to this path
    # from your flake's root directory and not by a direct path literal like ./secrets
    localStorageDir = ../secrets/rekeyed/${config.networking.hostName};
  };
}
