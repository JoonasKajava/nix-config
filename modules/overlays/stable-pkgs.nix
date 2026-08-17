{inputs, ...}: {
  flake-file.inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
  };

  den.aspects.base.nixos = {
    nixpkgs.overlays = [
      (final: prev: {
        stable = import inputs.nixpkgs-stable {
          inherit (final) system;
          config.allowUnfree = true;
        };
      })
    ];
  };
}
