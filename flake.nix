{
  description = "NixOS configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    agenix.url = "github:ryantm/agenix";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    nvf.url = "github:notashelf/nvf";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      agenix,
      nur,
      home-manager,
      nvf,
      ...
    }:
    let
      ifExists = p: nixpkgs.lib.optional (builtins.pathExists p) p;
    in
    {
      # TODO!!!!
      # kharon
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
      nixosConfigurations = nixpkgs.lib.genAttrs [ "pantheon" "hermes" "kharon" ] (
        name:
        nixpkgs.lib.nixosSystem {
          modules = [
            ./configurations/common.nix # thanks Katalin
            ./configurations/${name}.nix
          ]
          ++ (ifExists ./configurations/hw-${name}.nix)
          ++ [
            { nixpkgs.hostPlatform = "x86_64-linux"; } # thanks isabelroses
            agenix.nixosModules.default
            nvf.nixosModules.default
            home-manager.nixosModules.home-manager
            { networking.hostName = name; }
          ];
          specialArgs = { inherit inputs self; };
        }
      );
    };
}
