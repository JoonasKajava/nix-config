{
  lib,
  pkgs,
  config,
  namespace,
  ...
}:
with lib; let
  cfg = config.${namespace}.desktop.kde.plasma-manager;
  wallpaper = "/etc/nixos/nix-config-private/wallpapers/wallhaven-g8dm6e_3840x2160.png";
in {
  options.${namespace}.desktop.kde.plasma-manager = {
    enable = mkEnableOption "plasma manager";
  };

  config = mkIf cfg.enable {
    programs.plasma = {
      enable = true;

      workspace = {
        inherit wallpaper;
        theme = mkDefault "breeze-dark";
        colorScheme = mkDefault "BreezeDark";
        cursor = mkDefault {
          theme = "breeze_cursors";
          size = 24;
        };
        windowDecorations = {
          library = mkDefault "org.kde.breeze";
          theme = mkDefault "Breeze";
        };
      };

      hotkeys.commands."1password-quick-access" = {
        name = "Open Quick Access";
        key = "Ctrl+Alt+Shift+P";
        command = "1password --quick-access";
      };

      shortcuts = {
        "kwin"."Window Maximize" = ["Meta+Up"];
        "kwin"."Close Window" = ["Meta+Q"];
      };

      panels = [
        {
          location = "bottom";
          screen = [0 1 2]; # "all" does not work for some reason
          floating = true;
          height = 44;
          lengthMode = "fill";
          widgets = [
            {
              kickoff = {
                icon = "nix-snowflake-white";
              };
            }
            {
              iconTasks = {
                appearance = {
                  indicateAudioStreams = false;
                };
                settings.General = {
                  interactiveMute = false;
                };
                launchers =
                  [
                    "preferred://filemanager"
                    "preferred://browser"
                    "file://${pkgs.ferdium}/share/applications/ferdium.desktop"
                  ]
                  # ++ [
                  #   "file://${pkgs.brave}/share/applications/brave-browser.desktop"
                  #   # If one of these is not working, just generate new shortcuts from brave and check the app id
                  #   "file:///home/joonas/.local/share/applications/brave-hnpfjngllnobngcgfapefoaidbinmjnm-Default.desktop" # Whatsapp
                  #   "file:///home/joonas/.local/share/applications/brave-nkbljeindhmekmppbpgebpjebkjbmfaj-Default.desktop" # Fastmail
                  # ]
                  ++ [
                    "file://${pkgs.obsidian}/share/applications/obsidian.desktop"
                  ]
                  ++ [
                    "file://${pkgs.steam}/share/applications/steam.desktop"
                  ]
                  ++ [
                    "file://${pkgs._1password-gui}/share/applications/1password.desktop"
                  ]
                  ++ [
                    "file://${pkgs.discord}/share/applications/discord.desktop"
                  ];
              };
            }
            {
              name = "org.kde.plasma.systemmonitor.cpucore";
            }
            {
              systemTray.items = {
                hidden = ["org.kde.plasma.brightness"];
              };
            }
            {
              digitalClock = {
                time = {
                  format = "24h";
                  showSeconds = "always";
                };
                calendar = {
                  firstDayOfWeek = "monday";
                  showWeekNumbers = true;
                };
              };
            }
          ];
        }
      ];

      window-rules = [
        {
          description = "Kitty";
          match.window-class = "kitty kitty";
          apply = {
            maximizehoriz = true;
            maximizevert = true;
            noborder = true;
          };
        }
      ];

      kwin = {
        effects = {
          shakeCursor.enable = false;
          wobblyWindows.enable = true;
        };
      };

      dataFile = {
        "dolphin/view_properties/global/.directory"."Settings"."HiddenFilesShown" = true;
      };
    };
  };
}
