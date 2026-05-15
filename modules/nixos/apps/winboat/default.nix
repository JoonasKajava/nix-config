{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.apps.winboat;
in {
  options.${namespace}.apps.winboat = {
    enable = mkEnableOption "Whether to install Winboat";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      winboat
    ];
    virtualisation.docker = {
      enable = true;

      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
    users.users.${config.${namespace}.user.name}.extraGroups = ["docker"];
  };
}
