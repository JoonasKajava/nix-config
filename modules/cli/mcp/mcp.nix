{den, ...}: {
  den.aspects.mcp = {
    includes = with den.aspects; [
      sops
      # mcp.brave-search
      mcp.exa
    ];
    nixos = {
      sops.secrets."github-mcp-token" = {
        owner = "joonas";
      };
    };
    homeManager = {
      pkgs,
      lib,
      osConfig,
      ...
    }: {
      programs.mcp = {
        enable = true;
        servers = {
          nixos = {
            command = lib.getExe pkgs.mcp-nixos;
            enabled = true;
          };
          github = {
            command = lib.getExe pkgs.github-mcp-server;
            args = ["stdio" "--read-only"];
            enabled = true;
            env = {
              GITHUB_READ_ONLY = "1";
              GITHUB_PERSONAL_ACCESS_TOKEN.file = osConfig.sops.secrets."github-mcp-token".path;
            };
          };
          context7 = {
            command = lib.getExe pkgs.context7-mcp;
            enabled = true;
          };
        };
      };
    };
  };
}
