{
  den.aspects.cli.homeManager = {
    programs.yazi = {
      enable = true;
      settings = {
        mgr = {
          show_hidden = true;
        };
      };

      shellWrapperName = "y";
    };
  };
}
