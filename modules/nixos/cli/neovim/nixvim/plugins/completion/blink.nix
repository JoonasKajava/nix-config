{
  config,
  lib,
  pkgs,
  ...
}:
{
  extraPlugins =
    let
      mkPkgs = name: src: pkgs.vimUtils.buildVimPlugin { inherit name src; };
    in
    [
      (mkPkgs "blink.compat" pkgs.vimPlugins.blink-compat)
    ];

  plugins = lib.mkMerge [
    {
      blink-cmp = {
        enable = true;
        luaConfig.pre =
          # lua
          ''
            require('blink.compat').setup({debug = true, impersonate_nvim_cmp = true})
          '';

        settings = {
          completion = {
            accept.auto_brackets.enabled = true;
            ghost_text.enabled = true;
            documentation = {
              auto_show = true;
              window.border = "rounded";
            };
            menu = {
              border = "rounded";
              draw = {
                columns = [
                  {
                    __unkeyed-1 = "label";
                    __unkeyed-2 = "label_description";
                    gap = 1;
                  }
                  {
                    __unkeyed-1 = "kind_icon";
                    __unkeyed-2 = "kind";
                    gap = 1;
                  }
                ];
              };
            };
          };
          appearance = {
            use_nvim_cmp_as_default = true;
          };
          keymap = {
            preset = "enter";
            "<A-Tab>" = [
              "snippet_forward"
              "fallback"
            ];
            "<A-S-Tab>" = [
              "snippet_backward"
              "fallback"
            ];
            "<Tab>" = [
              "select_next"
              "fallback"
            ];
            "<S-Tab>" = [
              "select_prev"
              "fallback"
            ];
          };
          signature = {
            enabled = true;
            window.border = "rounded";
          };
          snippets.preset = "luasnip";
          sources = {
            default = [
              "buffer"
              "calc"
              "cmdline"
              "emoji"
              "git"
              "lsp"
              #"npm"
              "path"
              "snippets"
              "spell"
              #"treesitter"
              "zsh"
              "copilot"
            ];
            providers = {
              calc = {
                name = "calc";
                module = "blink.compat.source";
              };
              cmdline = {
                name = "cmdline";
                module = "blink.compat.source";
              };
              luasnip = {
                name = "luasnip";
                module = "blink.compat.source";
                score_offset = -3;
                opts = {
                  use_show_condition = false;
                  show_autosnippets = true;
                };
              };
              copilot = {
                async = true;
                name = "copilot";
                module = "blink-copilot";
                score_offset = 100;
                opts = {
                  max_completions = 3;
                  max_attempts = 4;
                  kind = "Copilot";
                  debounce = 750;
                  auto_refresh = {
                    backward = true;
                    forward = true;
                  };
                };
              };
              emoji = {
                name = "emoji";
                module = "blink.compat.source";
              };
              git = {
                name = "git";
                module = "blink.compat.source";
              };
              npm = {
                name = "npm";
                module = "blink.compat.source";
              };
              spell = {
                name = "spell";
                module = "blink.compat.source";
              };
              #treesitter = {
              #    name = "treesitter";
              #    module = "blink.compat.source";
              #  };
              zsh = {
                name = "zsh";
                module = "blink.compat.source";
              };
            };
          };
        };
      };
    }
    (lib.mkIf config.plugins.blink-cmp.enable {
      cmp-calc.enable = true;
      cmp-cmdline.enable = true;
      cmp-emoji.enable = true;
      cmp-git.enable = true;
      #cmp-nixpkgs_maintainers.enable = true;
      cmp-npm.enable = true;
      cmp-spell.enable = true;
      cmp-treesitter.enable = true;
      cmp-zsh.enable = true;

      lsp.capabilities =
        # Lua
        ''
          capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)
        '';
    })
  ];
}
