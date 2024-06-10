{pkgs, ...}: {
  packages = with pkgs; [stylua];

  languages.nix.enable = true;
  languages.lua.enable = true;

  enterTest = ''
    nix flake check
  '';

  # https://devenv.sh/pre-commit-hooks/
  # pre-commit.hooks.shellcheck.enable = true;

  # https://devenv.sh/processes/
  # processes.ping.exec = "ping example.com";

  # See full reference at https://devenv.sh/reference/options/
}
