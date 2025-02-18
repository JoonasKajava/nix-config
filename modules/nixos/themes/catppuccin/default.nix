{
  lib,
  config,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  catppuccinAccent = config.catppuccin.accent;
  catppuccinFlavor = config.catppuccin.flavor;

  capitalizeWord = word: let
    firstLetter = builtins.substring 0 1 word;
    rest = builtins.substring 1 (builtins.stringLength word - 1) word;
  in "${lib.toUpper firstLetter}${rest}";

  cfg = config.${namespace}.themes.catppuccin;
in {
  options.${namespace}.themes.catppuccin = {
    enable = mkEnableOption "Whether to enable the catppuccin theme.";
  };

  # TODO: window decorations look awful maybe because of not using kvantum?
  # TODO: Application style is missing
  config = mkIf cfg.enable {
    myHome = {
      catppuccin = {
        enable = true;
        nvim.enable = false;
        kvantum.enable = false;
      };
      programs.plasma.workspace = {
        colorScheme = "Catppuccin${capitalizeWord catppuccinFlavor}${capitalizeWord catppuccinAccent}";
        cursor = {
          theme = "catppuccin-${catppuccinFlavor}-dark-cursors";
          size = 24;
        };
        # Look and feel?
        # theme?
      };
    };

    environment.systemPackages = with pkgs; [
      (catppuccin-kde.override {
        accents = ["${catppuccinAccent}"];
        flavour = ["${catppuccinFlavor}"];
      })
      catppuccin-cursors."${catppuccinFlavor}Dark"
    ];

    boot.plymouth.enable = true;

    catppuccin = {
      enable = true;
      flavor = "mocha";
    };
  };
}
