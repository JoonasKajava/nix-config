{den, ...}: {
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
    }: let
      default_model = "openai/gpt-5.6-terra";
    in {
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
        package = pkgs.stable.opencode;
        settings =
          (
            builtins.readFile ./opencode-config.jsonc
            |> builtins.fromJSON
          )
          // {
            autoupdate = false;
            plugin = ["micode"];
            model = default_model;
          };
        context = ./opencode-context.md;
      };

      home.file.".config/opencode/micode.json".text =
        {
          agents = {
            commander.model = default_model;
            brainstormer.model = default_model;
            planner.model = default_model;
            executor.model = default_model;
            implementer.model = default_model;
            reviewer.model = default_model;
          };
        }
        |> builtins.toJSON;
    };
  };
}
