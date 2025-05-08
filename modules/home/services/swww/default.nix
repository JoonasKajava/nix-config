{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) types mkEnableOption mkOption mkIf;

  cfg = config.${namespace}.services.swww;

  switch-script = pkgs.writeShellScriptBin "swww-switch" ''
    #!/usr/bin/env bash
    swww img $1 --transition-step 1 --transition-fps 165
  '';

  mkScriptOption = script:
    mkOption {
      type = types.package;
      default = script;
    };
in {
  options.${namespace}.services.swww = {
    enable = mkEnableOption "Whether to enable swww.";
    switchScriptBin = mkScriptOption switch-script;
  };

  config = mkIf cfg.enable {
    # Wallpapers
    services.swww.enable = true;

    # TODO: maybe create systemd timer to change wallpapers according to time of the day.
  };
}
