{
  description = "My NixOS configurations for Joonas Kajava";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixos-wsl = {
      url = "github:nix-community/nixos-wsl";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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

  outputs = inputs@{ self, nixpkgs, home-manager, plasma-manager, nixos-wsl, ... }:
  let
    user = {
      username = "joonas";
      name = "Joonas Kajava";
    };
  in
   {
    nixosConfigurations = {
      nixos-zeus = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # Also _module.args or config._module.args
        specialArgs = {
          desktop = "kde";
          inherit plasma-manager home-manager user;
        };
        modules = [
          ./hosts/nixos-zeus
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit inputs user;};
            home-manager.users.${user.username} = import ./home;
          }
        ];

      };
      nixos-hermes = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # Also _module.args or config._module.args
        specialArgs = {
         desktop = "gnome";
         inherit home-manager user;
        };
        modules = [
         ./hosts/nixos-hermes
         home-manager.nixosModules.home-manager
         {
           home-manager.useGlobalPkgs = true;
           home-manager.useUserPackages = true;
           home-manager.extraSpecialArgs = {inherit inputs user;};
           home-manager.users.${user.username} = import ./home;
         }
        ];
     };
     nixos-athena = nixpkgs.lib.nixosSystem {
             system = "x86_64-linux";
             # Also _module.args or config._module.args
             specialArgs = {
              inherit home-manager user;
             };
             modules = [
             nixos-wsl.nixosModules.wsl
              ./hosts/nixos-athena
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
