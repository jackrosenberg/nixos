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
    {
      self,
      nixpkgs,
      agenix,
      home-manager,
      nvf,
      ...
    }:
    let
      ifExists = p: nixpkgs.lib.optional (builtins.pathExists p) p;
      inherit (nixpkgs) lib; # thanks sigmasquadron
    in
    {
      # TODO!!!!
      # kharon
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
      nixosConfigurations = lib.genAttrs [ "pantheon" "hermes" "kharon" ] (
        name:
        lib.nixosSystem {
          modules = [
            ./configurations/${name}.nix
          ]
          ++ lib.optional (name != "kharon") ./configurations/common.nix # thanks Katalin
          ++ (ifExists ./configurations/hw-${name}.nix)
          ++ [
            { nixpkgs.hostPlatform = "x86_64-linux"; } # thanks isabelroses
            agenix.nixosModules.default
            nvf.nixosModules.default
            home-manager.nixosModules.home-manager
            { networking.hostName = name; }
          ];
          specialArgs = { 
            inherit self;
            inherit (self) inputs;
          };
        }
      );
    };
}
