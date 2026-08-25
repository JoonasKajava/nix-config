# defines all hosts + users + homes.
# then config their aspects in as many files you want
{
  den.hosts.x86_64-linux = {
    nixos-desktop = {
      users.joonas = {
        classes = ["homeManager"];
      };
    };
    nixos-laptop = {
      users.joonas = {
        classes = ["homeManager"];
      };
    };

    nixos-home-server = {
      users.joonas = {
        classes = ["homeManager"];
      };
    };

    nixos-wsl = {
      wsl.enable = true;
      users.joonas = {
        classes = ["homeManager"];
      };
    };
  };
}
