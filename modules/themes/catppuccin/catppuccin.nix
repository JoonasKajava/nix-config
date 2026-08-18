{inputs, ...}: {
  flake-file.inputs = {
    catppuccin.url = "github:catppuccin/nix";
  };

  den.aspects.themes.catppuccin = {
    homeManager = {
      lib,
      osConfig,
      ...
    }: let
      catppuccinAccent = osConfig.catppuccin.accent;
      catppuccinFlavor = osConfig.catppuccin.flavor;

      capitalizeWord = word: let
        firstLetter = builtins.substring 0 1 word;
        rest = builtins.substring 1 (builtins.stringLength word - 1) word;
      in "${lib.toUpper firstLetter}${rest}";
    in {
      imports = [
        inputs.catppuccin.homeModules.catppuccin
      ];

      catppuccin = {
        autoEnable = true;
        enable = true;
        nvim.enable = false;
        kvantum.enable = true;
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

      qt = {
        enable = true;
        platformTheme.name = "kvantum";
        style = {
          name = "kvantum";
          catppuccin = {
            enable = true;
            apply = true;
            accent = catppuccinAccent;
            flavor = catppuccinFlavor;
          };
        };
      };
    };

    nixos = {pkgs, ...}: {
      modules = [
        inputs.catppuccin.nixosModules.catppuccin
      ];
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
        accent = "sapphire";
      };

      qt = {
        enable = true;
        platformTheme = "qt5ct";
        style = "kvantum";
      };
    };
  };
}
