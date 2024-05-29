{config, ...}: {
  imports = [./system.nix ./zsh.nix ./1password.nix ./nvidia.nix ./studio.nix];

  config.mystuff = {zsh.enable = true;};
}
