{
  pkgs,
  lib,
  user,
  home-manager,
  ...
}: {
  imports = [
    home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${user.username} = {
      # The home.stateVersion option does not have a default and must be set
      home.stateVersion = "18.09";

      home.username = user.username;
      home.homeDirectory = "/home/${user.username}";

      programs.git = {
        enable = true;
        userName = user.name;
        userEmail = user.githubEmail;
        extraConfig = {
          safe.directory = "/etc/nixos";
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

      programs.home-manager = {
        enable = true;
      };
      # Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ];
    };
  };
}
