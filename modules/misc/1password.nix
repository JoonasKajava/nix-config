{
  config,
  lib,
  user,
  ...
}:
with lib; let
  cfg = config.mystuff.onepassword;
in {
  options.mystuff.onepassword = {
    enable = mkEnableOption "1 password";
  };

  #
  # Migrated to Snowfall
  #
  config = mkIf cfg.enable {
    programs._1password.enable = true;
    programs._1password-gui = {
      enable = true;
      polkitPolicyOwners = [user.username];
    };

    services.gnome.gnome-keyring.enable = true;

    # I will not use 1password ssh agent since it is difficult to manage multiple keys with it
    # Also automated tasks cannot use it.
  };
}
