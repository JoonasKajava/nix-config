{
  description = "My NixOS configurations for Joonas Kajava";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
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
    nixpkgs-stable,
    home-manager,
    nixos-wsl,
    ...
  }: let
    user = {
      username = "joonas";
      name = "Joonas Kajava";
      githubEmail = "5013522+JoonasKajava@users.noreply.github.com";
    };

    defaultSpecialArgs = system: {
      inherit inputs home-manager user;
      pkgs-stable = import nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
      };
    };

    defaultModules = [./nix-config-private/private.nix ./home/default.nix];
  in {
    nixosConfigurations = {
      nixos-desktop = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        # Also _module.args or config._module.args
        specialArgs =
          defaultSpecialArgs system
          // {
            desktop = "kde";
          };
        modules =
          defaultModules
          ++ [
            ./hosts/nixos-desktop
          ];
      };
      nixos-laptop = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        # Also _module.args or config._module.args
        specialArgs =
          defaultSpecialArgs system
          // {
            desktop = "gnome";
          };
        modules =
          defaultModules
          ++ [
            ./hosts/nixos-laptop
          ];
      };
      nixos-wsl = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        # Also _module.args or config._module.args
        specialArgs = defaultSpecialArgs system;
        modules =
          defaultModules
          ++ [
            nixos-wsl.nixosModules.wsl
            ./hosts/nixos-wsl
          ];
      };
    };
  };
}
