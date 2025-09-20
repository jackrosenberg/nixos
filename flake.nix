{
  description = "NixOS configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    agenix.url = "github:ryantm/agenix";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
   {
    # TODO!!!!
    # kharon
    nixosConfigurations = nixpkgs.lib.genAttrs ["pantheon" "hermes"]
    (name: nixpkgs.lib.nixosSystem {
          modules = [
           ./configurations/common.nix # thanks Katalin
           ./configurations/${name}.nix
           ./configurations/hw-${name}.nix
           { nixpkgs.hostPlatform = "x86_64-linux"; } # thanks isabelroses
           agenix.nixosModules.default
           nur.modules.nixos.default
           nvf.nixosModules.default
           home-manager.nixosModules.home-manager
           {networking.hostName = name;}
          ];
          specialArgs = { inherit inputs self; };
        });
    };
}
