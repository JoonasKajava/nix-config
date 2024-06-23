{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mystuff.firefox;
in {
  options.mystuff.firefox = {
    enable = mkEnableOption "Enable firefox";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      firefoxpwa
    ];
    programs.firefox = {
      enable = true;
      package = pkgs.firefox;
      nativeMessagingHosts.packages = [pkgs.firefoxpwa];
    };
  };
}
