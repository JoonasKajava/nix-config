{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  git-hooks.hooks.flake-check = {
    enable = true;
    name = "Run flake check";
    entry = "nix flake check";
    always_run = true;
    verbose = true;
    pass_filenames = false;
  };
}
