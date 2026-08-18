{den, ...}: {
  den.aspects.tailscale = {
    includes = [
      den.aspects.sops
    ];
    nixos = {
      services.tailscale = {
        enable = true;
        permitCertUid = "caddy";
        openFirewall = true;
      };

      systemd.services.tailscaled-autoconnect = {
        after = ["sops-nix.service"];
      };
    };
  };
}
