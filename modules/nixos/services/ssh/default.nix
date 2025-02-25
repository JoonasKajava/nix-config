{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.services.ssh;
in {
  options.${namespace}.services.ssh = {
    enable = mkEnableOption "Whether to enable ssh services";
  };

  config = mkIf cfg.enable {
    users.users.${config.${namespace}.user.name}.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC/I9fBvav2dg4zYvScZ/+ipDEs68WylJAEYTYwwRWDk"
    ];

    services = {
      openssh = {
        enable = true;
        settings.PasswordAuthentication = false;
        settings.KbdInteractiveAuthentication = false;
      };
      resolved.enable = true;
      fail2ban = {
        enable = true;
        bantime-increment.enable = true;
      };
    };
  };
}
