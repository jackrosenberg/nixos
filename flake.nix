{
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

  outputs = inputs@{ self, nixpkgs, agenix, nur, home-manager, nvf, ... }: {
    nixosConfigurations = {
      # Todo, make this a switch
      hermes = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          { nixpkgs.hostPlatform = "x86_64-linux"; } # thanks isabelroses
          agenix.nixosModules.default
          nur.modules.nixos.default
          nvf.nixosModules.default
          # bomboclat, i now understand
          home-manager.nixosModules.home-manager
        ];
      };
    };
  };
}
