{
  den,
  user,
  ...
}: {
  den.aspects.gui = {
    nixos = {
      lib,
      config,
      ...
    }: {
      programs._1password.enable = true;
      programs._1password-gui = {
        enable = true;
        polkitPolicyOwners = [user.name];
      };

      environment.etc = {
        "1password/custom_allowed_browsers" = let
          list = lib.optionals true ["vivaldi-bin"]; # TODO: Add option for this.
        in {
          text = lib.concatStringsSep "\n" list;
          mode = "0755";
        };
      };

      services.gnome.gnome-keyring.enable = true;
    };
  };
}
