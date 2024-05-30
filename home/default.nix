{
  pkgs,
  lib,
  user,
  ...
}: {
  # The home.stateVersion option does not have a default and must be set
  home.stateVersion = "18.09";

  home.username = user.username;
  home.homeDirectory = "/home/${user.username}";

  programs.git = {
    enable = true;
    userName = user.name;
    userEmail = "5013522+JoonasKajava@users.noreply.github.com";
    extraConfig = {
      safe.directory = "/etc/nixos";
      # gpg.format = "ssh";
      # gpg."ssh".program = "/opt/1Password/op-ssh-sign";
      # commit.gpgsign = true;
      # user.signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDBW2Rddbmwj9W61WtcXqu3HEFCC7hg81pRaqZRlHTPt";
      push.autoSetupRemote = true;
    };
  };

  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
      };
      git.paging.externalDiffCommand = "difft --color=always";
      customCommands = [
        {
          key = "c";
          command = "git cz c";
          description = "Commit with commitizen";
          context = "files";
          loadingText = "Opening commitizen commit tool";
          subprocess = true;
        }
      ];
    };
  };

  programs.ssh = {
    enable = true;
  };

  programs.home-manager.enable = true;
  # Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ];
}
