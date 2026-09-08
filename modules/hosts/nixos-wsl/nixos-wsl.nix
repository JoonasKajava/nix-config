{den, ...}: {
  flake-file.inputs = {
    nixos-wsl = {
      url = "github:nix-community/nixos-wsl";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.aspects.nixos-wsl = {
    includes = with den.aspects; [
      cli
      base
      opencode
    ];

    homeManager.home.stateVersion = "26.05";
    nixos = {
      users.users.joonas.linger = true;

      home-manager.startAsUserService = true;

      system.stateVersion = "26.05";
      wsl.defaultUser = "joonas";
    };
  };
}
