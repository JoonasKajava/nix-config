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

    snowfallorg.users.${config.${namespace}.user.name}.home.config = {
      ${namespace}.cli.neovim.enable = true;
    };

    programs.neovim = {
      enable = true;
      defaultEditor = true;
    };
    nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

    programs.direnv.enable = true;

    environment = {
      variables.EDITOR = "nvim";
      systemPackages = with pkgs; [
        lazygit
        wl-clipboard
      ];
    };

    fonts.packages = with pkgs.nerd-fonts; [
      fira-mono
    ];
  };
}
