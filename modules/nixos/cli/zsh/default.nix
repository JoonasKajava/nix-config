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
          source ~/.secrets.sh
          eval "$(direnv hook zsh)"
        '';
        shellAliases = {
          rebuild = "cd /etc/nixos/;nh os switch --ask .\\?submodules=1; source ~/.zshenv; source ~/.zshrc";
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
