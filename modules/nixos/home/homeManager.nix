{
  den.aspects.base.nixos = {
    home-manager = {
      backupFileExtension = "hm-backup";
      useGlobalPkgs = true;
      useUserPackages = true;
    };
  };
}
