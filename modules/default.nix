{config, ...}: {
  imports = [./system.nix ./zsh.nix ./1password.nix];

  config.mystuff = {zsh.enable = true;};
}
