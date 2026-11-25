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

    nixos = {pkgs,...}: {
      environment.systemPackages = with pkgs; [
        dix
      ];

      nixpkgs.config.allowUnfree = true;

      nix = {
        settings = {experimental-features = ["nix-command flakes" "pipe-operators"];};
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
