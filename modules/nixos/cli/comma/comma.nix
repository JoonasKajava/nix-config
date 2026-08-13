{inputs, ...}: {
  flake-file.inputs = {
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };
  den.aspects.cli = {
    imports = [
      inputs.nix-index-database.homeModules.default
    ];
    homeManager = {
      programs.nix-index-database.comma.enable = true;
    };
  };
}
