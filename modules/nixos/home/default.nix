{
  lib,
  config,
  namespace,
  ...
}: let
  cfg = config.myHome;
in
  with lib;
  with lib.${namespace}; {
    options = {
      myHome = mkOption {
        type = types.attrsOf types.anything;
        description = "Allows nixos modules to easily configure the home-manager.";
        default = {};
      };

      ${namespace}.disableMyHome = mkBoolOpt false ''
        Whether to disable system configured home-manager.
        Enable this option if you want to use your own home-manager configuration.
        Or enable if you don't want NixOs modules to configure home-manager.
      '';
    };

    config = {
      snowfallorg.users.${config.${namespace}.user.name}.home.config = mkIf (config.${namespace}.disableMyHome == false) cfg;

      home-manager = {
        backupFileExtension = "hm-backup";
        useGlobalPkgs = true;
        useUserPackages = true;
      };
    };
  }
