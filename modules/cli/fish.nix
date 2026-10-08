{den, ...}: {
  den.aspects.fish = {
    nixos = {pkgs, ...}: {
      users.users.joonas.shell = pkgs.fish;
      programs.fish = {
        enable = true;
      };
    };
    homeManager = {
      lib,
      pkgs,
      ...
    }: {
      home.shell.enableFishIntegration = true;

      programs.nix-your-shell.enable = true;
      programs.fish = {
        enable = true;
        interactiveShellInit =
          ''
            eval (${lib.getExe pkgs.zellij} setup --generate-auto-start fish | string collect)

            ${lib.getExe pkgs.fastfetch}
          '';
      };
    };
  };
}
