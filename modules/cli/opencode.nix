{
  den.aspects.opencode.homeManager = {
    pkgs,
    lib,
    ...
  }: {
    programs.mcp = {
      enable = true;
      servers = {
        nixos = {
          command = lib.getExe pkgs.mcp-nixos;
          enabled = true;
        };
        context7 = {
          type = "local";
          command = lib.getExe pkgs.context7-mcp;
          enabled = true;
        };
      };
    };
    programs.opencode = {
      enableMcpIntegration = true;
      enable = true;
    };
  };
}
