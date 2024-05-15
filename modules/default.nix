{config, ...}: {
  imports = [./system.nix ./zsh.nix];

  config.mystuff = {zsh.enable = true;};
}
