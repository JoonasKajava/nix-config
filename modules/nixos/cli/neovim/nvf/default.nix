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

  cfg = config.${namespace}.cli.neovim.nvf;
in {
  options.${namespace}.cli.neovim.nvf = {
    enable = mkEnableOption "Whether to enable neovim with nvf";
  };

  config = mkIf cfg.enable {
    nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

    assertions = [
      {
        assertion = !config.${namespace}.cli.neovim.enable;
        message = ''
          cli.neovim.enable activates lazyvim, which conflicts with nvf.
        '';
      }
    ];

    programs.nvf = {
      enable = true;
      settings = {
        vim = {
          viAlias = true;
          vimAlias = true;

          luaConfigRC.myBasic =
            /*
            lua
            */
            ''
              vim.opt.clipboard = "unnamedplus"
            '';

          lsp = {
            enable = true;
            lspkind.enable = true;
            lightbulb.enable = true;
            lspsaga.enable = false; #TODO: maybe this?
            trouble = {
              enable = true;
              mappings = {
                documentDiagnostics = "<leader>xx"; # or <leader>xX
                locList = "<leader>xL";
                lspReferences = "<leader>cS";
                quickfix = "<leader>xQ";
                symbols = "<leader>cs";
              };
            };
            lspSignature.enable = true;
            lsplines.enable = true;

            mappings = {
              codeAction = "<leader>ca";
              format = "<leader>cf";
              goToDeclaration = "gD";
              goToDefinition = "gd";
              goToType = "gy";
              hover = "K";
              #listDocumentSymbols = "?"; # TODO: find
              #listImplementations = "?"; # TODO: find
              listReferences = "gr";
              nextDiagnostic = "]d";
              prevDiagnostic = "[d";
              renameSymbol = "<leader>cr";
              signatureHelp = "gK";
            };
          };

          debugger = {
            nvim-dap = {
              enable = true;
              ui.enable = true;
            };
          };

          languages = {
            enableLSP = true;
            enableFormat = true;
            enableTreesitter = true;
            enableExtraDiagnostics = true;

            nix = {
              enable = true;
              lsp = {
                server = "nixd";
                options = {
                  nixos = {
                    expr = "(builtins.getFlake (" git+file:// " + toString ./.)).nixosConfigurations.${config.networking.hostName}.options";
                  };
                  home_manager = {
                    expr = "(builtins.getFlake (" git+file:// " + toString ./.)).homeManagerConfigurations.${config.${namespace}.user.name}.options";
                  };
                };
              };
            };

            markdown.enable = true;
            bash.enable = true;
            clang.enable = true;

            css.enable = true;
            html.enable = true;
            sql.enable = true;
            ts.enable = true;
            lua.enable = true;
            python.enable = true;

            rust = {
              enable = true;
              crates.enable = true;
            };

            tailwind.enable = true;
          };

          visuals = {
            nvim-scrollbar.enable = true;
            nvim-web-devicons.enable = true;
            fidget-nvim.enable = true;
            highlight-undo.enable = true;
            indent-blankline.enable = true;
          };

          statusline.lualine = {
            enable = true;
            theme = "auto";
          };

          theme = {
            enable = true;
            name = "catppuccin";
            style = "mocha";
            transparent = false;
          };

          autopairs.nvim-autopairs.enable = true;
          autocomplete.blink-cmp = {
            enable = true;
            mappings = {
              confirm = "<CR>";
              next = "<Up>";
              previous = "<Down>";
            };
          };
          snippets.luasnip.enable = true;

          # TODO: Replace with oil.nvim
          filetree = {
            neo-tree = {
              enable = true;
              mappings.toggle = "<leader>e";
            };
          };
          tabline = {
            nvimBufferline.enable = true;
          };

          treesitter.context.enable = true;

          binds = {
            whichKey.enable = true;
            cheatsheet.enable = true;
          };

          telescope = {
            enable = true;
            mappings = {
              diagnostics = "<leader>sd";
              findFiles = "<leader><space>";
              liveGrep = "<leader>/";
              lspDefinitions = "<leader>fd";
              lspDocumentSymbols = "<leader>ss";
            };
          };

          git = {
            enable = true;
            gitsigns.enable = true;
            gitsigns.codeActions.enable = false; # throws an annoying debug message
          };

          dashboard = {
            alpha.enable = true;
          };

          notify.nvim-notify.enable = true;
          utility = {
            surround.enable = true;
            diffview-nvim.enable = true;
            # TODO: flash.nvim is missing
          };

          notes = {
            todo-comments = {
              enable = true;
              mappings = {
                telescope = "<leader>st";
              };
            };
          };

          terminal = {
            toggleterm = {
              enable = true;
              lazygit.enable = true;
            };
          };

          ui = {
            borders.enable = true;
            noice.enable = false;
            colorizer.enable = true;
            breadcrumbs = {
              enable = true;
              navbuddy.enable = true;
            };

            fastaction.enable = true;
          };

          assistant = {
            # TODO: Add chatgpt
            copilot = {
              enable = true;
              cmp.enable = true;
            };
          };

          comments.comment-nvim.enable = true;
        };
      };
    };
  };
}
