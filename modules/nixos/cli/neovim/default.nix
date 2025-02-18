{
  lib,
  config,
  namespace,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) types mkEnableOption mkIf mkOption;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.cli.neovim;
  mkLangOption = lang:
    mkOption {
      type = types.bool;
      default = true;
      description = "${lang} support";
    };
in {
  #TODO: Copy lazyvim config to this module
  options.${namespace}.cli.neovim = {
    enable = mkEnableOption "Whether to enable neovim with my configuration";
    lang = {
      rust = mkLangOption "rust";
      lua = mkLangOption "lua";
      python = mkLangOption "python";
      typescript = mkLangOption "typescript";
      nix = mkLangOption "nix";
      markdown = mkLangOption "markdown";
      html = mkLangOption "html";
      bash = mkLangOption "bash";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !config.${namespace}.cli.neovim.nvf.enable;
        message = ''
          cli.neovim.nvf.enable activates nvf, which conflicts with lazyvim.
        '';
      }
    ];

    myHome = {
      ${namespace}.cli.neovim.enable = true;
    };

    programs.neovim = {
      enable = true;
      defaultEditor = true;
    };
    nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

    nix.settings = {
      trusted-public-keys = ["devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="];
      substituters = ["https://devenv.cachix.org"];
      trusted-users = ["root" config.${namespace}.user.name];
    };

    programs.direnv.enable = true;

    environment = {
      variables.EDITOR = "nvim";
      systemPackages = with pkgs; [
        lazygit
        devenv
        wl-clipboard
      ];
    };

    fonts.packages = with pkgs.nerd-fonts; [
      fira-mono
    ];
  };
}
