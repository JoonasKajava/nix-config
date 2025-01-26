{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.mystuff.kde.plasma-manager;
  wallpaper = "/etc/nixos/nix-config-private/wallpapers/4K Mountain Moon Night - Nguyez.jpeg";
in {
  options.mystuff.kde.plasma-manager = {
    enable = mkEnableOption "plasma manager";
  };

  #
  # Migrated to Snowfall
  #
  config = mkIf cfg.enable {
    home-manager.users.${user.username} = {
      programs.plasma = {
        enable = true;

        workspace.wallpaper = wallpaper;

        hotkeys.commands."1password-quick-access" = mkIf config.mystuff.onepassword.enable {
          name = "Open Quick Access";
          key = "Ctrl+Alt+Shift+P";
          command = "1password --quick-access";
        };

        shortcuts = {
          "kwin"."Window Maximize" = ["Meta+Up"];
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
                  launchers =
                    [
                      "applications:systemsettings.desktop"
                      "preferred://filemanager"
                    ]
                    ++ (lib.optionals config.mystuff.brave.enable [
                      "file://${pkgs.brave}/share/applications/brave-browser.desktop"
                      # If one of these is not working, just generate new shortcuts from brave and check the app id
                      "file:///home/joonas/.local/share/applications/brave-hnpfjngllnobngcgfapefoaidbinmjnm-Default.desktop" # Whatsapp
                      "file:///home/joonas/.local/share/applications/brave-nkbljeindhmekmppbpgebpjebkjbmfaj-Default.desktop" # Fastmail
                    ])
                    ++ (lib.optionals config.mystuff.office.obsidian.enable [
                      "file://${pkgs.obsidian}/share/applications/obsidian.desktop"
                    ])
                    ++ (lib.optionals config.mystuff.gaming.steam.enable [
                      "file://${pkgs.steam}/share/applications/steam.desktop"
                    ])
                    ++ (lib.optionals config.mystuff.onepassword.enable [
                      "file://${pkgs._1password-gui}/share/applications/1password.desktop"
                    ])
                    ++ (lib.optionals config.mystuff.discord.enable [
                      "file://${pkgs.discord}/share/applications/discord.desktop"
                    ]);
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
  };
}
