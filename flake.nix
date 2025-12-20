rec {
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    agenix.url = "github:ryantm/agenix";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    nvf.url = "github:notashelf/nvf/v0.8";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      agenix,
      home-manager,
      nvf,
      disko,
      lanzaboote,
      ...
    }:
    let
      inherit (nixpkgs) lib; # thanks sigmasquadron
      ifExists = p: lib.optional (builtins.pathExists p) p;
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
      nixosConfigurations = lib.genAttrs [ "pantheon" "hermes" "kharon" ] (
        name:
        lib.nixosSystem {
          modules = [
            ./configurations/${name}.nix
            agenix.nixosModules.default
            nvf.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              nixpkgs.hostPlatform = "x86_64-linux"; # thanks isabelroses
              networking.hostName = name;
            }
          ]
          ++ lib.optionals (name != "kharon") [ 
            ./configurations/common.nix # thanks Katalin
            disko.nixosModules.disko
            lanzaboote.nixosModules.lanzaboote
            ./configurations/disko-config.nix
          ]
          # import additional hw/disko configurations
          ++ (ifExists ./configurations/hw-${name}.nix)
          ++ (ifExists ./configurations/disko-${name}.nix);
          specialArgs = {
            inherit self;
            inherit (self) inputs;
          };
        }
      );
    };
}
