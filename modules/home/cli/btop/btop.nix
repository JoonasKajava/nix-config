{
  den.aspects.cli.homeManager = {pkgs, ...}: {
    home.shellAliases = {
      htop = "btop";
    };
    programs.btop = {
      enable = true;
      settings = {
        vim_keys = true;
        cpu_single_graph = true;
      };
    };
  };
}
