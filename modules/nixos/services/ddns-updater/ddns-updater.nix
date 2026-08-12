{
  den.aspects.ddns-updater = {
    nixos = {config, lib,...}: {

    services.ddns-updater = {
      enable = true;
      environment = {
        TZ = "Europe/Berlin";
        CONFIG_FILEPATH = config.sops.secrets.home-server-ddns-config.path;
        LOG_LEVEL = "debug";
        RESOLVER_ADDRESS = "1.1.1.1:53";
      };
    };

    users.users.ddns-updater = {
      isSystemUser = true;
      group = "ddns-updater";
      description = "Dynamic DNS Updater Service User";
      createHome = false;
    };

    users.groups.ddns-updater = {};

    systemd.tmpfiles.settings.ddns-updater = {
      "/var/lib/ddns-updater/updates.json" = {
        f = {
          group = "ddns-updater";
          user = "ddns-updater";
          mode = "0660";
        };
      };
    };

    systemd.services.ddns-updater = {
      after = ["sops-nix.service"];
      serviceConfig = {
        DynamicUser = lib.mkForce false;
        User = "ddns-updater";
        Group = "ddns-updater";
      };
    };
    };
  };
}
