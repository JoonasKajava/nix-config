{
  description = "My NixOS configurations for Joonas Kajava";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }: {

    nixosConfigurations = {
      nixos-zeus = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        extraArgs = {
          desktop = "gnome";
        };
        modules = [
          ./hosts/nixos-zeus
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = inputs;
            home-manager.users.joonas = import ./home;
          }
        ];

      };
    };

  };
}
