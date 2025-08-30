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

  outputs = inputs@{ self, nixpkgs, agenix, nur, home-manager, nvf, ... }: {
    nixosConfigurations = {
      pantheon = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          { nixpkgs.hostPlatform = "x86_64-linux"; } # thanks isabelroses
          agenix.nixosModules.default
          nur.modules.nixos.default
          nvf.nixosModules.default
          home-manager.nixosModules.home-manager
          # dont understand this syntax....
          # now i do, and i need to remove it
          {
            home-manager = { 
              useGlobalPkgs = true;
              useUserPackages = true;
              users.jack = import ./home.nix;
            };
          }
        ];
      };
    };
  };
}
