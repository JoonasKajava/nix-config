{
  lib,
  config,
  namespace,
  ...
}:
with lib; let
  cfg = config.${namespace}.apps._1password;
  inherit (lib.${namespace}) useVivaldi;
  inherit (lib.strings) concatStringsSep;
in {
  options.${namespace}.apps._1password = {enable = mkEnableOption "Whether or not to enable 1password.";};

  config = mkIf cfg.enable {
    programs._1password.enable = true;
    programs._1password-gui = {
      enable = true;
      polkitPolicyOwners = [config.${namespace}.user.name];
    };

    environment.etc = {
      "1password/custom_allowed_browsers" =
        let
          list = lib.optionals useVivaldi ["vivaldi-bin"];
        in
        {
        text = concatStringsSep "\n" list;
        mode = "0755";
      };
    };

    services.gnome.gnome-keyring.enable = true;

    # I will not use 1password ssh agent since it is difficult to manage multiple keys with it
    # Also automated tasks cannot use it.
  };
}
