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
        interactiveShellInit = ''

          ${lib.getExe pkgs.fastfetch}
        '';
      };
    };
  };
}
