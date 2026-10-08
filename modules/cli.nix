{den, ...}: {
  den.aspects.cli = {
    nixos = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        tldr
        rm-improved
        just
        nh
      ];
    };

    includes = with den.aspects; [
      fish
      git
      neovim.nvf
      ssh
    ];
  };
}
