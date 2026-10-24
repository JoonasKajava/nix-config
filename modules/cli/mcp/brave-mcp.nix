{
  den.aspects.mcp.brave-search = {
    nixos = {
      sops.secrets."brave-search-api-key" = {
        owner = "joonas";
      };
    };
    homeManager = {
      pkgs,
      osConfig,
      ...
    }: {
      programs.mcp = {
        servers = {
          brave-search = {
            command = "${pkgs.nodejs}/bin/npx";
            args = ["-y" "@brave/brave-search-mcp-server"];
            env = {
              BRAVE_API_KEY_FILE = osConfig.sops.secrets."brave-search-api-key".path;
            };
          };
        };
      };
    };
  };
}
