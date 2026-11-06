{den, ...}: {
  den.aspects.codex = {
    includes = with den.aspects; [
      mcp
      skills
      agent-context
    ];
    homeManager = {
      programs.codex = {
        enable = true;
        enableMcpIntegration = true;
        settings = {
          tui = {
            vim_mode_default = true;
          };
        };
      };
    };
  };
}
