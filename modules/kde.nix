let
  wallpaper = "/etc/nixos/nix-config-private/wallpapers/wallhaven-g8dm6e_3840x2160.png";
in {
  flake-file.inputs = {
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  den.aspects.desktop.kde = {
    nixos = {
      pkgs,
      user,
      ...
    }: {
      environment = {
        plasma6.excludePackages = with pkgs.kdePackages; [
          kate
          elisa
        ];

        systemPackages = with pkgs.kdePackages; [
          kcolorchooser
          filelight
          (spectacle.override {
            tesseractLanguages = ["eng" "fin"];
          })
        ];
      };

      services = {
        xserver = {
          enable = true;
        };

        displayManager = {
          autoLogin.enable = true;
          autoLogin.user = user.name;
          defaultSession = "plasma";
          sddm = {
            wayland.enable = true;
            enable = true;
          };
        };

        desktopManager.plasma6.enable = true;
      };

      #   qt = {
      #     enable = true;
      #    platformTheme = "gnome";
      #   style = "adwaita-dark";
      #  };

      programs.dconf.enable = true;
    };

    homeManager = {
      pkgs,
      inputs,
      ...
    }: {
      imports = [
        inputs.plasma-manager.homeModules.plasma-manager
      ];

      programs.plasma = {
        enable = true;
        workspace = {
          inherit wallpaper;
          theme = "breeze-dark";
          colorScheme = "BreezeDark";
          cursor = {
            theme = "breeze_cursors";
            size = 24;
          };
          windowDecorations = {
            library = "org.kde.breeze";
            theme = "Breeze";
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
  };
}
