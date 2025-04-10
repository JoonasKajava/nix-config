{
  lib,
  config,
  namespace,
  system,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.cli.neovim.nvf;
in {
  options.${namespace}.cli.neovim.nvf = {
    enable = mkEnableOption "Whether to enable neovim with nvf";
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = [
        inputs.my-nvf.packages.${system}.default
      ];

      variables.EDITOR = "nvim";
    };
  };
}
