{
  den.aspects.zed.homeManager = {
    pkgs,
    lib,
    ...
  }: {
    home.packages = with pkgs; [
      jetbrains-mono
    ];
    programs.zed-editor = {
      enable = true;
      package = pkgs.zed-editor-fhs;
      userSettings = {
        git = {
          inline_blame = "on";
        };
        code_lens = "on";
        diagnostics = {
          inline = {
            enabled = true;
          };
        };
        toolbar = {
          code_actions = true;
        };
        auto_signature_help = false;
        ui_font_family = "JetBrains Mono";
        buffer_font_family = "JetBrains Mono";
        buffer_font_features = {
          calt = false;
        };
        vim = {
          toggle_relative_line_numbers = true;
        };

        base_keymap = "VSCode";
        icon_theme = "Zed (Default)";
        theme = {
          mode = "dark";
          light = "One Light";
          dark = "One Dark";
        };
        which_key = {
          delay_ms = 500;
          enabled = true;
        };

        inlay_hints = {
          enabled = true;
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
