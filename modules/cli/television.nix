{
  den.aspects.cli.homeManager = {
    programs.television = {
      enable = true;
      enableNushellIntegration = true;
      settings = {
        shell_integration.channel_triggers."files" = ["sops"];
      };
    };
  };
}
