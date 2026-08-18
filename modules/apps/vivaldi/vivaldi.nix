{
  den.aspects.browsers.vivaldi.homeManager = {
    pkgs,
    config,
    ...
  }: {
    home.packages = with pkgs; [
      vivaldi
      kdePackages.plasma-browser-integration
    ];

    home.file.".config/vivaldi/custom.css".source =
      config.lib.file.mkOutOfStoreSymlink
      "/etc/nixos/modules/home/apps/vivaldi/custom.css";
  };
}
