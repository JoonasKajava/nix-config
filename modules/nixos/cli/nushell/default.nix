{
  lib,
  pkgs,
  config,
  namespace,
  ...
}:
with lib; let
  cfg = config.${namespace}.cli.nushell;
in {
  options.${namespace}.cli.nushell = {enable = mkEnableOption "nushell";};

  config = mkIf cfg.enable {
    users.defaultUserShell = pkgs.nushell;

    snowfallorg.users.${config.${namespace}.user.name}.home.config = {
      programs.nushell = {
        enable = true;
        extraConfig = ''
          $env.config.edit_mode = 'vi'
        '';
      };
    };
  };
}
