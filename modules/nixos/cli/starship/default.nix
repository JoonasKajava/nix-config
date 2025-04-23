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
          firstSegmentColor = "#dcdcdc";
          secondSegmentColor = "#0c72cb";
        in {
          format = mkSingleLine ''
            $os
            $username
            [](bg:${secondSegmentColor} fg:${firstSegmentColor})
            $directory
            [](fg:#DA627D bg:#FCA17D)
            $git_branch
            $git_status
            [](fg:#FCA17D bg:#86BBD8)
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
            [](fg:#86BBD8 bg:#06969A)
            $docker_context
            [ ](fg:#33658A)
          '';

          right_format = mkSingleLine ''
            $status
            [](fg:${firstSegmentColor})
            $time
          '';
          #TODO: add time to the right
          add_newline = false;
          username = rec {
            show_always = true;
            style_user = "bg:${firstSegmentColor} #000000";
            style_root = style_user;
            format = "[$user ]($style)";
          };
          os = {
            style = "bg:${firstSegmentColor} black";
            disabled = false;
            format = "[ $symbol ]($style)";
          };
          directory = {
            style = "bg:${secondSegmentColor}";
            format = "[ $path ]($style)";
            truncation_length = 3;
            fish_style_pwd_dir_length = 2;
            substitutions = {
              "Documents" = "󰈙 ";
              "Downloads" = " ";
              "Music" = " ";
              "Pictures" = " ";
            };
          };

          c = {
            symbol = " ";
            style = "bg:#86BBD8";
            format = "[ $symbol ($version) ]($style)";
          };
          docker_context = {
            symbol = " ";
            style = "bg:#06969A";
            format = "[ $symbol $context ]($style)";
          };
          elixir = {
            symbol = " ";
            style = "bg:#86BBD8";
            format = "[ $symbol ($version) ]($style)";
          };
          elm = {
            symbol = " ";
            style = "bg:#86BBD8";
            format = "[ $symbol ($version) ]($style)";
          };
          git_branch = {
            symbol = "";
            style = "bg:#FCA17D";
            format = "[ $symbol $branch ]($style)";
          };
          git_status = {
            style = "bg:#FCA17D";
            format = "[$all_status$ahead_behind ]($style)";
          };
          golang = {
            symbol = " ";
            style = "bg:#86BBD8";
            format = "[ $symbol ($version) ]($style)";
          };
          gradle = {
            style = "bg:#86BBD8";
            format = "[ $symbol ($version) ]($style)";
          };
          haskell = {
            symbol = " ";
            style = "bg:#86BBD8";
            format = "[ $symbol ($version) ]($style)";
          };
          java = {
            symbol = " ";
            style = "bg:#86BBD8";
            format = "[ $symbol ($version) ]($style)";
          };
          julia = {
            symbol = " ";
            style = "bg:#86BBD8";
            format = "[ $symbol ($version) ]($style)";
          };
          nodejs = {
            symbol = "";
            style = "bg:#86BBD8";
            format = "[ $symbol ($version) ]($style)";
          };
          nim = {
            symbol = "󰆥 ";
            style = "bg:#86BBD8";
            format = "[ $symbol ($version) ]($style)";
          };
          rust = {
            symbol = "";
            style = "bg:#86BBD8";
            format = "[ $symbol ($version) ]($style)";
          };
          scala = {
            symbol = " ";
            style = "bg:#86BBD8";
            format = "[ $symbol ($version) ]($style)";
          };
          time = {
            disabled = false;
            style = "bg:${firstSegmentColor} #000000";
            format = "[ $time ]($style)";
          };
        };
      };
    };
  };
}
