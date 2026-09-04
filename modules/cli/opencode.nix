{den,...}:{
  den.aspects.opencode = {
    includes = with den.aspects; [
      sops
      skills
    ];
    nixos = {
      sops.secrets."brave-search-api-key" = {
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
          context7 = {
            type = "local";
            command = lib.getExe pkgs.context7-mcp;
            enabled = true;
          };
          brave-search = {
            command = "${pkgs.nodejs}/bin/npx";
            args = ["-y" "@brave/brave-search-mcp-server"];
            env = {
              BRAVE_API_KEY_FILE = osConfig.sops.secrets."brave-search-api-key".path;
            };
          };
        };
      };
      programs.opencode = {
        enableMcpIntegration = true;
        enable = true;
      };
    };
  };
}
