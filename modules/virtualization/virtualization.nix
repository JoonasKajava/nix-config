{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mystuff.virtualization;
in {
  options.mystuff.virtualization.enable = mkEnableOption "Virtualization";

  config = mkIf cfg.enable {
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;
  };
}
