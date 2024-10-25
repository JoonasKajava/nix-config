{
  lib,
  pkgs,
  user,
  config,
  ...
}:
with lib; let
  cfg = config.mystuff.zsh;
in {
  options.mystuff.zsh = {enable = mkEnableOption "Zsh";};

  config = mkIf cfg.enable {
    programs.zsh = {enable = true;};

    users.defaultUserShell = pkgs.zsh;

    home-manager.backupFileExtension = "hm-backup";

    home-manager.users.${user.username} = {
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        initExtra = ''
          source /etc/nixos/assets/theme.zsh
          source ~/.secrets.sh
          eval "$(direnv hook zsh)"
        '';
        shellAliases = {
          rebuild = "sudo nixos-rebuild switch; source ~/.zshenv; source ~/.zshrc";
          upgrade = "cd /etc/nixos/;devenv update;nix flake update";
          optimize = "devenv gc; sudo sh -c 'nix-collect-garbage -v -d && nix-store -v --optimize'";
          neofetch = "fastfetch";
          l = "eza -hlaog --total-size --icons";
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
        ];
      };
    };
  };
}
