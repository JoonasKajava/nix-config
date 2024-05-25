{config, ...}: {
  imports = [./system.nix ./zsh.nix ./1password.nix ./nvidia.nix];

  config.mystuff = {zsh.enable = true;};
}
