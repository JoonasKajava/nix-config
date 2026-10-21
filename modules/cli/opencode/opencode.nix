{den, ...}: {
  den.aspects.opencode = {
    includes = with den.aspects; [
      mcp
      skills
      sops
    ];
    nixos = {
      sops.secrets."brave-search-api-key" = {
        owner = "joonas";
      };
    };
    homeManager = {pkgs, ...}: let
      default_model = "openai/gpt-5.6-terra";
    in {
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
