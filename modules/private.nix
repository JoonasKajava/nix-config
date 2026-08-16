{inputs, ...}: {
  flake-file.inputs = {
    nix-config-private = {
      url = "git+ssh://git@github.com/JoonasKajava/nix-config-private?ref=den";
      flake = false;
    };
  };

  imports = [
    (inputs.import-tree (inputs.nix-config-private + /modules))
  ];
}
