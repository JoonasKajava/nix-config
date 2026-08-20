{
  den.aspects.cli.homeManager = {
    pkgs,
    lib,
    ...
  }: {
    programs.mcp = {
      enable = true;
      servers = {
        nixos = {
          command = lib.getExe pkgs.mcp-nixos;
        };
      };
    };
    programs.opencode = {
      enableMcpIntegration = true;
      enable = true;
    };
  };
}
