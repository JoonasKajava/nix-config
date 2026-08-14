{inputs, ...}: {
  flake-file.inputs = {
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  den.aspects.lanzaboote = {
    nixos = {lib, ...}: {
      modules = [
        inputs.lanzaboote.nixosModules.lanzaboote
      ];
      boot = {
        loader.systemd-boot.enable = lib.mkForce false;
        lanzaboote = {
          enable = true;
          pkiBundle = "/var/lib/sbctl/";
        };
      };
    };
  };
}
