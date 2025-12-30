rec {
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    agenix.url = "github:ryantm/agenix";
    agenix-rekey = {
      url = "github:oddlama/agenix-rekey";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
      flake-utils,
      agenix,
      agenix-rekey,
      home-manager,
      nvf,
      disko,
      lanzaboote,
      ...
    }:
    let
      inherit (nixpkgs) lib; # thanks sigmasquadron
      ifExists = p: lib.optional (builtins.pathExists p) p;
      systems = {
        pantheon = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILPdyrnxYVvwgr874QrS9nrXrqpK299d4isNCmUkOqwq";
        hermes = "todo";
        # kharon = null;
      };
    in
    lib.recursiveUpdate 
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
      nixosConfigurations = lib.genAttrs (builtins.attrNames systems) (
        hostName:
        lib.nixosSystem {
          modules = [
            ./configurations/${hostName}.nix
            nvf.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              nixpkgs.hostPlatform = "x86_64-linux"; # thanks isabelroses
              networking = { inherit hostName; };
            }
          ]
          ++ lib.optionals (hostName != "kharon") [
            ./configurations/common.nix # thanks Katalin
            disko.nixosModules.disko
            lanzaboote.nixosModules.lanzaboote
            agenix.nixosModules.default
            agenix-rekey.nixosModules.default
            ./configurations/disko-config.nix
            {
              age.rekey = {
                hostPubkey = systems.${hostName}; # big baller moves 
              };
            }
          ]
          # import additional hw/disko configurations
          ++ (ifExists ./configurations/hw-${hostName}.nix)
          ++ (ifExists ./configurations/disko-${hostName}.nix);
          specialArgs = {
            inherit self;
            inherit (self) inputs;
          };
        }
      );
      agenix-rekey = agenix-rekey.configure {
        userFlake = self;
        nixosConfigurations = self.nixosConfigurations;
      };
    }
    (flake-utils.lib.eachDefaultSystem (system: rec {
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ agenix-rekey.overlays.default ];
      };
      devShells.default = pkgs.mkShell {
        packages = [ pkgs.agenix-rekey ];
        # ...
      };
    }));
}
