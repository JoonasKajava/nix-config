{
  den.aspects.appimage.nixos = {pkgs, ...}: {
    programs.appimage = {
      enable = true;
      binfmt = true;
    };
  };
}
