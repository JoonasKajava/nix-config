{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs";
    nixos-wsl = {
      url = "github:nix-community/nixos-wsl";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lumi-private = {
      url = "git+ssh://git@github.com/JoonasKajava/nix-config-private";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.snowfall-lib.follows = "snowfall-lib";
    };
  };

  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;

      snowfall = {
        namespace = "lumi";
        meta = {
          name = "lumi";
          title = "Lumi, the NixOS configuration";
        };
      };

      channels-config = {
        allowUnfree = true;
      };

      homes.modules = with inputs; [
	plasma-manager.homeManagerModules.plasma-manager
      ];

      systems.modules.nixos = with inputs; [
        lumi-private.nixosModules."scripts/ssh-setup"
        lumi-private.nixosModules."scripts/setup-env-secrets"
	# TODO: learn how to import all
      ];
      # systems.hosts.nixos-wsl.modules = with inputs; [
      #   nixos-wsl.nixosModules.wsl
      # ];
    };
}
