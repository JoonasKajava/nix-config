{
  lib,
  config,
  pkgs,
  namespace,
  ...
}: let
  cfg = config.${namespace}.apps.zed;
in {
  options.${namespace}.apps.zed = {
    enable = lib.mkEnableOption "Enable Zed editor";
  };

  config = lib.mkIf cfg.enable {
    programs.zed-editor = {
      enable = true;
      package = pkgs.zed-editor-fhs;
      userSettings = {
        diagnostics = {
          inline = {
            enabled = true;
          };
        };

        "vim" = {
          "toggle_relative_line_numbers" = true;
        };

        base_keymap = "VSCode";
        "icon_theme" = "Zed (Default)";
        "theme" = {
          "mode" = "dark";
          "light" = "One Light";
          "dark" = "One Dark";
        };
        vim_mode = true;
        lsp = {
          nil = {
            binary.path = lib.getExe pkgs.nil;
          };

          nixd = {
            binary.path = lib.getExe pkgs.nixd;
            settings = {
              options = {
                "home-manager" = {
                  "expr" = ''(builtins.getFlake "/etc/nixos").homeConfigurations.joonas.options'';
                };
                "nixos-desktop" = {
                  "expr" = ''(builtins.getFlake "/etc/nixos").nixosConfigurations.nixos-desktop.options'';
                };
              };
            };
          };
        };
      };
    };
  };
}
