{
  den.aspects.base = {
    homeManager = {
      home.file.".config/nixpkgs/config.nix".text =
        /*
        Nix
        */
        ''
          {
            allowUnfree = true;
          }
        '';
    };

    nixos = {
      nixpkgs.config.allowUnfree = true;

      nix = {
        settings = {experimental-features = ["nix-command flakes"];};
        settings.auto-optimise-store = true;

        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 7d";
        };
      };
    };
  };
}
