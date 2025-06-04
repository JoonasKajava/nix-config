{
  options,
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.user;
in {
  options.${namespace}.user = with lib.types; {
    name = mkOpt str "joonas" "The name to use for the user account.";
    fullName = mkOpt str "Joonas Kajava" "The full name of the user.";
    githubEmail = mkOpt str "5013522+JoonasKajava@users.noreply.github.com" "The github email of the user.";
    initialPassword =
      mkOpt str "password"
      "The initial password to use when the user is first created.";
    extraGroups = mkOpt (listOf str) [] "Groups for the user to be assigned.";
    extraOptions = mkOpt attrs {} (mdDoc "Extra options passed to `users.users.<name>`.");
  };

  config = {
    users.users.${cfg.name} =
      {
        isNormalUser = true;
        inherit (cfg) name initialPassword;
        description = cfg.fullName;
        extraGroups = ["networkmanager" "wheel"] ++ cfg.extraGroups;
        hashedPasswordFile = config.${namespace}.secrets."hashed-password/${cfg.name}".path;
      }
      // cfg.extraOptions;
  };
}
