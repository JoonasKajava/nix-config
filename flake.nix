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
    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    plasma-manager,
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
          desktop = "gnome";
          inherit inputs home-manager user;
        };
        modules = [
          ./hosts/nixos-desktop
        ];
      };
      nixos-laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # Also _module.args or config._module.args
        specialArgs = {
          desktop = "gnome";
          inherit home-manager user inputs;
        };
        modules = [
          ./hosts/nixos-laptop
        ];
      };
      nixos-wsl = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # Also _module.args or config._module.args
        specialArgs = {inherit home-manager user inputs;};
        modules = [
          nixos-wsl.nixosModules.wsl
          ./hosts/nixos-wsl
        ];
      };
    };
  };
}
