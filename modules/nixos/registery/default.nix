{
  lib,
  config,
  ...
}: let
  inherit (lib) types mkOption;

  cfg = config.registery;
in {
  options.registery = {
    importantDirs = mkOption {
      type = types.listOf types.str;
      description = ''
        important directories that should be backed up.
      '';
      example = [
        "/var/lib/paperless/"
      ];
    };
  };
}
