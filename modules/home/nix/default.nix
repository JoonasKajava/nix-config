{...}: {
  config = {
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
}
