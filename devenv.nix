{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  git-hooks.hooks.flake-check = {
    enable = false; # disable for now since it's quite slow
    name = "Run flake check";
    entry = "nix flake check";
    always_run = true;
    verbose = true;
    pass_filenames = false;
  };
}
