{inputs, ...}: {
  flake-file.inputs = {
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.aspects.stylix = {
    nixos = {pkgs, ...}: {
      modules = [
        inputs.stylix.nixosModules.stylix
      ];

      stylix.enable = true;
      stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-moon.yaml";
    };
  };
}
