{
  lib,
  config,
  namespace,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.cli.neovim.nixvim;
in {
  options.${namespace}.cli.neovim.nixvim = {
    enable = mkEnableOption "Whether to enable neovim and configure it with nixvim";
  };

  config = mkIf cfg.enable {
    nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];
    programs.nixvim = {
      imports = [
        ./settings.nix
        ./lazy.nix
        ./keymaps.nix
        ./autocmd.nix
        ./plugins/imports.nix
      ];
    };
  };
}
