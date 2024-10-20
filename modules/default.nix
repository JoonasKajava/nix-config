{config, ...}: {
  imports = [
    ./office/obsidian.nix
    ./audio/easyeffects.nix
    ./1password.nix
    ./firefox.nix
    ./gaming/mangohud.nix
    ./gnome.nix
    ./hyprland/hyprland.nix
    ./kde.nix
    ./nvidia.nix
    ./studio.nix
    ./system.nix
    ./zsh.nix

    ../work/knowit.nix
  ];

  config.mystuff = {zsh.enable = true;};
}
