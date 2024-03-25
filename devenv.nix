{ pkgs, ... }:

{
   packages = with pkgs; [
      nixfmt
      stylua
   ];

   languages.nix.enable = true;
   languages.lua.enable = true;

  # https://devenv.sh/pre-commit-hooks/
  # pre-commit.hooks.shellcheck.enable = true;

  # https://devenv.sh/processes/
  # processes.ping.exec = "ping example.com";

  # See full reference at https://devenv.sh/reference/options/
}
