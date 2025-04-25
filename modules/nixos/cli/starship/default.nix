{
  lib,
  pkgs,
  config,
  namespace,
  ...
}:
with lib; let
  cfg = config.${namespace}.cli.starship;
  mkSingleLine = str: builtins.replaceStrings ["\n"] [""] str;
in {
  options.${namespace}.cli.starship = {enable = mkEnableOption "starship";};

  config = mkIf cfg.enable {
    snowfallorg.users.${config.${namespace}.user.name}.home.config = {
      programs.starship = {
        enable = true;
        enableNushellIntegration = true;
        enableZshIntegration = true;
        settings = let
          firstSegmentColor = {
            bg = "#dcdcdc";
            fg = "#000000";
          };
          secondSegmentColor = {
            bg = "#0c72cb";
            fg = "white";
          };
          thirdSegmentColor = {
            bg = "yellow";
            fg = "black";
          };
          fourthSegmentColor = {
            bg = "#86BBD8";
            fg = "black";
          };
        in {
          format = mkSingleLine ''
            $os
            $username
            [](bg:${secondSegmentColor.bg} fg:${firstSegmentColor.bg})
            $directory
            [](fg:${secondSegmentColor.bg} bg:${thirdSegmentColor.bg})
            $git_branch
            $git_status
            [](fg:${thirdSegmentColor.bg} bg:${fourthSegmentColor.bg})
            $lua
            $c
            $elixir
            $elm
            $golang
            $gradle
            $haskell
            $java
            $julia
            $nodejs
            $nim
            $rust
            $scala
            $dotnet
            $docker_context
            $nix_shell
            [ ](fg:${fourthSegmentColor.bg})
          '';

          #TODO: add duration
          right_format = mkSingleLine ''
            $status
            [](fg:${firstSegmentColor.bg})
            $time
          '';
          add_newline = true;

          username = rec {
            show_always = true;
            style_user = "bg:${firstSegmentColor.bg} ${firstSegmentColor.fg}";
            style_root = style_user;
            format = "[$user ]($style)";
          };
          os = {
            style = "bg:${firstSegmentColor.bg} ${firstSegmentColor.fg}";
            disabled = false;
            format = "[ $symbol]($style)";
          };
          directory = {
            style = "bg:${secondSegmentColor.bg} bold";
            truncate_to_repo = false;
            format = "[ $path ]($style)";
            truncation_length = 3;
            fish_style_pwd_dir_length = 2;
            home_symbol = "󰋜 ~";
            substitutions = {
              "Documents" = "󰈙 Documents";
              "Downloads" = " Downloads";
              "Music" = " Music";
              "Pictures" = " Pictures";
              "Development" = "  Development";
            };
          };

          c = {
            symbol = " ";
            style = "bg:${fourthSegmentColor.bg} ${fourthSegmentColor.fg}";
            format = "[ $symbol ($version) ]($style)";
          };
          lua = {
            symbol = " ";
            style = "bg:${fourthSegmentColor.bg} ${fourthSegmentColor.fg}";
            format = "[ $symbol ($version) ]($style)";
          };
          docker_context = {
            symbol = " ";
            style = "bg:${fourthSegmentColor.bg} ${fourthSegmentColor.fg}";
            format = "[ $symbol $context ]($style)";
          };
          elixir = {
            symbol = " ";
            style = "bg:${fourthSegmentColor.bg} ${fourthSegmentColor.fg}";
            format = "[ $symbol ($version) ]($style)";
          };
          elm = {
            symbol = " ";
            style = "bg:${fourthSegmentColor.bg} ${fourthSegmentColor.fg}";
            format = "[ $symbol ($version) ]($style)";
          };
          git_branch = {
            symbol = "";
            style = "bg:${thirdSegmentColor.bg} ${thirdSegmentColor.fg}";
            format = "[( $symbol $branch )]($style)";
          };
          git_status = {
            style = "bg:${thirdSegmentColor.bg} ${thirdSegmentColor.fg}";
            modified = " $count";
            format = "[($all_status )]($style)";
          };
          golang = {
            symbol = " ";
            style = "bg:${fourthSegmentColor.bg} ${fourthSegmentColor.fg}";
            format = "[ $symbol ($version) ]($style)";
          };
          gradle = {
            style = "bg:${fourthSegmentColor.bg} ${fourthSegmentColor.fg}";
            format = "[ $symbol ($version) ]($style)";
          };
          haskell = {
            symbol = " ";
            style = "bg:${fourthSegmentColor.bg} ${fourthSegmentColor.fg}";
            format = "[ $symbol ($version) ]($style)";
          };
          java = {
            symbol = " ";
            style = "bg:${fourthSegmentColor.bg} ${fourthSegmentColor.fg}";
            format = "[ $symbol ($version) ]($style)";
          };
          julia = {
            symbol = " ";
            style = "bg:${fourthSegmentColor.bg} ${fourthSegmentColor.fg}";
            format = "[ $symbol ($version) ]($style)";
          };
          nodejs = {
            symbol = "";
            style = "bg:${fourthSegmentColor.bg} ${fourthSegmentColor.fg}";
            format = "[ $symbol ($version) ]($style)";
          };
          nim = {
            symbol = "󰆥 ";
            style = "bg:${fourthSegmentColor.bg} ${fourthSegmentColor.fg}";
            format = "[ $symbol ($version) ]($style)";
          };
          rust = {
            symbol = "";
            style = "bg:${fourthSegmentColor.bg} ${fourthSegmentColor.fg}";
            format = "[ $symbol ($version) ]($style)";
          };
          scala = {
            symbol = " ";
            style = "bg:${fourthSegmentColor.bg} ${fourthSegmentColor.fg}";
            format = "[ $symbol ($version) ]($style)";
          };
          dotnet = {
            style = "bg:${fourthSegmentColor.bg} ${fourthSegmentColor.fg}";
            format = "[ $symbol ($version) ]($style)";
          };
          nix_shell = {
            style = "bg:${fourthSegmentColor.bg} ${fourthSegmentColor.fg}";
            format = "[ nix-shell ]($style)";
          };
          status = {
            disabled = false;
            style = "bg:red yellow";
            success_style = "bg:none";
            success_symbol = "✔";
            format = "[ $symbol $status ]($style)";
          };
          time = {
            disabled = false;
            style = "bg:${firstSegmentColor.bg} ${firstSegmentColor.fg}";
            format = "[ $time  ]($style)";
          };
        };
      };
    };
  };
}
