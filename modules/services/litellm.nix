{den, ...}: {
  den.aspects.litellm = {
    includes = [
      den.aspects.caddy
      den.aspects.sops
    ];
    backup = {config, ...}: {
      patterns = [
        "+ ${config.services.litellm.stateDir}"
      ];
    };
    nixos = {
      config,
      pkgs,
      ...
    }: let
      port = 4000;
      dbPort = 39645;
      host = "litellm.joonaskajava.com";
      stateDir = "/var/lib/litellm";
    in {
      services.caddy = {
        enable = true;
        virtualHosts = {
          ${host}.extraConfig = ''
            reverse_proxy http://127.0.0.1:${toString port}
            import cloudflare
          '';
        };
      };

      sops = {
        secrets = {
          litellm-db-password = {};
          litellm-master-key = {};
          litellm-salt-key = {};
        };
        templates = {
          "litellm-db-env" = {
            content = ''
              POSTGRES_USER=litellm
              POSTGRES_PASSWORD=${config.sops.placeholder."litellm-db-password"}
              POSTGRES_DB=litellm
            '';
          };

          "litellm-env" = {
            restartUnits = ["docker-litellm.service"];
            content = ''
              LITELLM_MASTER_KEY=${config.sops.placeholder."litellm-master-key"}
              LITELLM_SALT_KEY=${config.sops.placeholder."litellm-salt-key"}
              DATABASE_URL=postgresql://litellm:${config.sops.placeholder."litellm-db-password"}@localhost:${toString dbPort}/litellm
              STORE_MODEL_IN_DB=True
            '';
          };
        };
      };

      virtualisation = {
        oci-containers = {
          containers = {
            litellm = {
              image = "docker.litellm.ai/berriai/litellm:v1.90.2";
              dependsOn = ["litellm-db"];
              # ports = ["127.0.0.1:${toString port}:4000/tcp"];
              environmentFiles = [config.sops.templates."litellm-env".path];
              autoStart = true;
              extraOptions = ["--network=host"];
            };
            litellm-db = {
              image = "postgres:16";
              ports = ["127.0.0.1:${toString dbPort}:5432/tcp"];
              environmentFiles = [config.sops.templates."litellm-db-env".path];
              volumes = [
                "${stateDir}/db-data:/var/lib/postgresql/data:rw"
              ];
              autoStart = true;
            };
          };
        };
      };
    };
  };
}
