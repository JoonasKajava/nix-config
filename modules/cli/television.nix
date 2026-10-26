{
  den.aspects.cli.homeManager = {
    programs.television = {
      enable = true;
      enableNushellIntegration = true;
      settings = {
        shell_integration.channel_triggers = {
          dirs = ["cd" "ls" "rmdir"];
          files = ["mv" "cp" "nvim" "vim" "sops"];
        };
      };
    };
  };
}
