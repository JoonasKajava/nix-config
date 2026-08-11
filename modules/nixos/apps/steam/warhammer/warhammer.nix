{
  den.aspects.steam.warhammer.nixos = {
    networking.firewall = {
      allowedUDPPorts = [27015];
      allowedUDPPortRanges = [
        {
          from = 27031;
          to = 27036;
        }
      ];
      allowedTCPPorts = [27015 27027 27036];
    };
  };
}
