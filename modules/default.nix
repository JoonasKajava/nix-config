{config, ...}: {
  imports = [./system.nix ./zsh.nix ./1password.nix ./nvidia.nix ./studio.nix ./gaming/mangohud.nix];

  config.mystuff = {zsh.enable = true;};
}
