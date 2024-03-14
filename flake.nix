{
  description = "My NixOS configurations for Joonas Kajava";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, plasma-manager, ... }: {

    nixosConfigurations = {
      nixos-zeus = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # Also _module.args or config._module.args
        specialArgs = {
          desktop = "kde";
          inherit plasma-manager home-manager;
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
