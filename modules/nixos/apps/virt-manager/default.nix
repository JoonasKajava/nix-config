{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.apps.virt-manager;
in {
  options.${namespace}.apps.virt-manager = {
    enable = mkEnableOption "Whether to install virt-manager";
  };

  config = mkIf cfg.enable {
    users.users.${config.user.name}.extraGroups = ["libvirtd"];

    virtualisation = {
      libvirtd = {
        enable = true;
        qemu = {
          swtpm.enable = true;
          ovmf.enable = true;
          ovmf.packages = [pkgs.OVMFFull.fd];
        };
      };
      spiceUSBRedirection.enable = true;
    };

    services.spice-vdagentd.enable = true;

    programs.virt-manager.enable = true;

    environment.systemPackages = with pkgs; [
      quickemu
      virt-viewer
      spice
      spice-gtk
      spice-protocol
      win-virtio
      win-spice
      # gnome.adwaita-icon-theme
    ];
  };
}
