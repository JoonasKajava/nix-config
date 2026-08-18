{
  den.aspects.samba = let
    scanPath = "/var/scans";
  in {
    nixos = {pkgs, ...}: {
      services = {
        resolved.enable = true;
        samba = {
          package = pkgs.stable.sambaFull;
          enable = true;
          openFirewall = true;

          settings.scans = {
            path = scanPath;
            # set password for the users using sudo smbpasswd -a <username>
            security = "user";
            writable = true;
          };
        };
      };
    };
  };
}
