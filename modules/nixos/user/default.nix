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
    extraGroups = mkOpt (listOf str) [] "Groups for the user to be assigned.";
    extraOptions = mkOpt attrs {} (mdDoc "Extra options passed to `users.users.<name>`.");
  };

  config = {
    users.users.${cfg.name} =
      {
        isNormalUser = true;
        inherit (cfg) name;
        description = cfg.fullName;
        extraGroups = ["networkmanager" "wheel" "postgres"] ++ cfg.extraGroups;
        # TODO: Fix this
        #hashedPasswordFile = config.sops.secrets."hashed-password/${cfg.name}".path;
      }
      // cfg.extraOptions;
  };
}
