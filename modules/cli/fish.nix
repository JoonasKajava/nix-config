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
          # fish_vi_key_bindings doesn't work well
          set -g fish_greeting

          eval (${lib.getExe pkgs.zellij} setup --generate-auto-start fish | string collect)

          ${lib.getExe pkgs.fastfetch}
        '';
      };
    };
  };
}
