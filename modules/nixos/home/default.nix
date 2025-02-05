{
  lib,
  pkgs,
  config,
  namespace,
  ...
}:
 {
  config = {
    home-manager = {
      backupFileExtension = "hm-backup";
      useGlobalPkgs = true;
      useUserPackages = true;
    };
  };
}
