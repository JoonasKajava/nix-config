{den, ...}: {
  den.aspects.claude = {
    includes = with den.aspects; [
      mcp
      skills
      agent-context
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
          env.CLAUDE_CODE_SCROLL_SPEED = "3";
        };
      };
    };
  };
}
