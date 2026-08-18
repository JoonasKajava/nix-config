{
  den.aspects.joonas.user = {
    extraGroups = ["libvirtd"];
  };

  den.aspects.virt-manager = {
    nixos = {
      pkgs,
      ...
    }: {
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
  };
}
