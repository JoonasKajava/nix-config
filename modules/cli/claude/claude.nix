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
