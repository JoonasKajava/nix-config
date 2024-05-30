{config, ...}: {
  imports = [./system.nix ./zsh.nix ./1password.nix ./nvidia.nix ./studio.nix ./home-manager.nix];

  config.mystuff = {
    zsh.enable = true;
    home-manager.enable = true;
  };
}
