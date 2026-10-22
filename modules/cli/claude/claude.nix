{den, ...}: {
  den.aspects.claude = {
    includes = with den.aspects; [
      mcp
      skills
    ];
    homeManager = {
      programs.claude-code = {
        enableMcpIntegration = true;
        enable = true;
        context = ./claude-context.md;
        settings = {
          editorMode = "vim";
          tui = "fullscreen";
          enabledPlugins."superpowers@claude-plugins-official" = true;
          attribution = false;
        };
      };
    };
  };
}
