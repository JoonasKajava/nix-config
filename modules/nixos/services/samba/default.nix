{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) types mkEnableOption mkIf mkOption;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.services.samba;
in {
  options.${namespace}.services.samba = {
    enable = mkEnableOption "Whether to enable samba services";
    printerPath = mkOption {
      type = types.str;
      description = "Specifies where printer should add scanned documents.";
      default = "/var/scans";
    };
  };

  config = mkIf cfg.enable {
    services = {
      resolved.enable = true;
      samba = {
        package = pkgs.sambaFull;
        enable = true;
        openFirewall = true;

        settings.scans = {
          path = cfg.printerPath;
          # set password for the users using sudo smbpasswd -a <username>
          security = "user";
          writable = true;
        };
      };
    };
  };
}
