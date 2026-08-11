  {
    den.schema.user = {
      lib,
      ...
    }: {
      options.gitEmail = lib.mkOption {default = "5013522+JoonasKajava@users.noreply.github.com";};
      options.gitName = lib.mkOption {default = "Joonas Kajava";};
    };

    den.aspects.git.homeManager = {user,...}: {

        programs.git = {
          enable = true;

          lfs.enable = true;
          settings = {
            user = {
              email = user.gitEmail;
              name = user.gitName;
            };

            init.defaultBranch = "main";

            safe.directory = "/etc/nixos";
            push.autoSetupRemote = true;
          };
        };
    };
  }
