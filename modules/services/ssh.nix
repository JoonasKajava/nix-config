{
  den.aspects.openssh = {
    nixos = {
      pkgs,
      ...
    }: {
      users.users.joonas.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC/I9fBvav2dg4zYvScZ/+ipDEs68WylJAEYTYwwRWDk"
      ];

      environment.systemPackages = with pkgs; [
        kitty.terminfo
      ];

      services = {
        openssh = {
          enable = true;
          settings.PasswordAuthentication = false;
          settings.KbdInteractiveAuthentication = false;
        };
        resolved.enable = true;
        fail2ban = {
          enable = true;
          bantime-increment.enable = true;
        };
      };
    };
  };
}
