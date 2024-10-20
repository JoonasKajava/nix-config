{config, ...}: {
  imports = [
    ./office/obsidian.nix
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
  ];

  config.mystuff = {zsh.enable = true;};
}
