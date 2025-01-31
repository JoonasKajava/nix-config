{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mystuff.brave;
in {
  #
  # Migrated to Snowfall
  #
  options.mystuff.brave = {
    enable = mkEnableOption "brave";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      brave
    ];

    nixpkgs.config.packageOverrides = pkgs: {
      intel-vaapi-driver = pkgs.intel-vaapi-driver.override {enableHybridCodec = true;};
    };

    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        libvdpau-va-gl
      ];
    };

    environment.sessionVariables = {LIBVA_DRIVER_NAME = "iHD";};
  };
}
