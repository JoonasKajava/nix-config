{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) types mkOption;
  inherit (lib.${namespace}.types) monitor;
in {
  options.${namespace}.hardware.monitors = mkOption {
    type = types.listOf monitor;
    default = [];
    description = ''
      A list of monitor configuration options.
      Each entry in the list is a submodule that
      configures a specific monitor.'';
  };
}
