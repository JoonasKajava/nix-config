{ den, ... }:
{
  # user aspect
  den.aspects.joonas = {
    includes = [
      den.batteries.define-user
      den.batteries.primary-user
      den.batteries.host-aspects
      # (den.batteries.user-shell "nushell")
    ];

    homeManager =
      { pkgs, ... }:
      {
      };

    # user can provide NixOS configurations
    # to any host it is included on
    provides.to-hosts.nixos = { pkgs, ... }: { };
  };
}
