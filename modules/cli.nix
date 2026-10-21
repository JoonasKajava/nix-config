{den, ...}: {
  den.aspects.cli = {
    nixos = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        tldr
        rm-improved
        just
        nh
        jq
      ];
    };

    includes = with den.aspects; [
      cli.nushell
      git
      neovim.nvf
      ssh
    ];
  };
}
