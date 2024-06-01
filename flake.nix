{
  description = "My NixOS configurations for Joonas Kajava";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-wsl = {
      url = "github:nix-community/nixos-wsl";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    nixos-wsl,
    ...
  }: let
    user = {
      username = "joonas";
      name = "Joonas Kajava";
    };
  in {
    nixosConfigurations = {
      nixos-desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # Also _module.args or config._module.args
        specialArgs = {
          desktop = "kde";
          inherit home-manager user;
        };
        modules = [
          ./hosts/nixos-desktop
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit inputs user;};
            home-manager.users.${user.username} = import ./home;
          }
        ];
      };
      nixos-laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # Also _module.args or config._module.args
        specialArgs = {
          desktop = "gnome";
          inherit home-manager user;
        };
        modules = [
          ./hosts/nixos-laptop
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit inputs user;};
            home-manager.users.${user.username} = import ./home;
          }
        ];
      };
      nixos-wsl = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # Also _module.args or config._module.args
        specialArgs = {inherit home-manager user;};
        modules = [
          nixos-wsl.nixosModules.wsl
          ./hosts/nixos-wsl
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit inputs user;};
            home-manager.users.${user.username} = import ./home;
          }
        ];
      };
    };
  };
}
