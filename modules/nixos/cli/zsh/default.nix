{
  lib,
  pkgs,
  config,
  namespace,
  ...
}:
with lib; let
  cfg = config.${namespace}.cli.zsh;
in {
  options.${namespace}.cli.zsh = {enable = mkEnableOption "Zsh";};

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      nh
    ];

    fonts.packages = with pkgs.nerd-fonts; [
      fira-mono
    ];

    programs.zsh.enable = true; # Necessary even when enabled by home-manager.

    users.defaultUserShell = pkgs.zsh;

    snowfallorg.users.${config.${namespace}.user.name}.home.config = {
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        initExtra = ''
          source /etc/nixos/modules/nixos/cli/zsh/theme.zsh
          source /etc/secrets.sh
          eval "$(direnv hook zsh)"
        '';
        shellAliases = {
          neofetch = "fastfetch";
        };

        history.size = 10000;
        plugins = [
          {
            name = "powerlevel10k";
            src = pkgs.zsh-powerlevel10k;
            file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
          }
          {
            name = "vi-mode";
            src = pkgs.zsh-vi-mode;
            file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
          }
          {
            name = "zsh-nix-shell";
            src = pkgs.zsh-nix-shell;
            file = "share/zsh-nix-shell/nix-shell.plugin.zsh";
          }
        ];
      };
    };
  };
}
