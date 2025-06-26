{
  lib,
  config,
  namespace,
  ...
}: {
  lumi = {
    apps = {
      #apps.anyrun.enable = true;
      naps2.enable = true;
      ludusavi.enable = true;

      #ferdium notifications are still not working
      ferdium.enable = false;
    };
  };
}
