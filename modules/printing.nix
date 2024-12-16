{
  config,
  lib,
  user,
  ...
}:
with lib; let
  cfg = config.mystuff.printing;
in {
  options.mystuff.printing = {
    enable = mkEnableOption "printing";
  };

  config = mkIf cfg.enable {
    services.printing.enable = true;
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}
