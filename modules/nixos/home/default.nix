{
  lib,
  config,
  namespace,
  ...
}: let
  cfg = config.myHome;
in
  with lib; {
    options.myHome = mkOption {
      type = types.attrsOf types.anything;
      default = {};
    };
    config = {
      snowfallorg.users.${config.${namespace}.user.name}.home.config = cfg;

      home-manager = {
        backupFileExtension = "hm-backup";
        useGlobalPkgs = true;
        useUserPackages = true;
      };
    };
  }
