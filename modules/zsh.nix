{ pkgs, user, ... }: {
  programs.zsh = { enable = true; };

  users.defaultUserShell = pkgs.zsh;

  home-manager.users.${user.username} = {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      initExtra = ''
        source /etc/nixos/assets/theme.zsh
        eval "$(direnv hook zsh)"
      '';
      shellAliases = {
        update = "sudo nixos-rebuild switch";
        optimize =
          "sudo sh -c 'devenv gc; nix-collect-garbage -v -d && nix-store -v --optimize'";
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
}
