{
  lib,
  config,
  pkgs,
  namespace,
  ...
}: {
  options.${namespace}.user = with lib; {
    name = mkOption {
      type = types.str;
      default = "joonas";
      description = "The user name";
    };
    fullName = mkOption {
      type = types.str;
      default = "Joonas Kajava";
      description = "The full name of the user";
    };
    githubEmail = mkOption {
      type = types.str;
      default = "5013522+JoonasKajava@users.noreply.github.com";
      description = "GitHub email address";
    };
  };
}
