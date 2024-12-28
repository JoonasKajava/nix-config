{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.mystuff.plasma-manager;
  mkPwaDesktopItem = {
    name,
    app,
    icon,
  }:
    pkgs.makeDesktopItem {
      name = "${name}-pwa-desktop";
      desktopName = name;
      exec = "${pkgs.brave}/bin/brave --app\"${app}\"";
    };
in {
  options.mystuff.plasma-manager = {
    enable = mkEnableOption "plasma manager";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.username} = {
      programs.plasma = {
        enable = true;

        hotkeys.commands."1password-quick-access" = mkIf config.mystuff.onepassword.enable {
          name = "Open Quick Access";
          key = "Ctrl+Alt+Shift+P";
          command = "1password --quick-access";
        };

        panels = [
          {
            location = "bottom";
            screen = "all";
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
                      "${pkgs.brave}/share/applications/brave-browser.desktop"
                      mkPwaDesktopItem
                      {
                        name = "Whatsapp";
                        app = "https://web.whatsapp.com/";
                        icon = builtins.fetchurl "https://static.whatsapp.net/rsrc.php/v4/yw/r/WDR7jNjkVfM.png";
                      }
                      mkPwaDesktopItem
                      {
                        name = "FastMail";
                        app = "https://app.fastmail.com/";
                        icon = builtins.fetchurl "https://app.fastmail.com/static/appicons/Icon-MacOS-512x512@2x.png";
                      }
                    ])
                    ++ (lib.optionals config.mystuff.office.obsidian.enable [
                      "${pkgs.obsidian}/share/applications/obsidian.desktop"
                    ])
                    ++ (lib.optionals config.mystuff.gaming.steam.enable [
                      "${pkgs.steam}/share/applications/steam.desktop"
                    ])
                    ++ (lib.optionals config.mystuff.onepassword.enable [
                      "${pkgs._1password-gui}/share/applications/1password.desktop"
                    ])
                    ++ (lib.optionals config.mystuff.discord.enable [
                      "${pkgs.discord-canary}/share/applications/discord-canary.desktop"
                    ]);
                };
              }
              {
                name = "org.kde.plasma.systemmonitor.cpucore";
              }
              "org.kde.plasma.systemtray"
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
            shakeCursor.enabled = false;
            wobblyWindows.enabled = true;
          };
        };

        dataFile = {
          "dolphin/view_properties/global/.directory"."Settings"."HiddenFilesShown" = true;
        };
      };
    };
  };
}
