{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./office/obsidian.nix
    ./audio/easyeffects.nix
    ./misc/1password.nix
    ./firefox.nix
    ./gaming/mangohud.nix
    ./gnome.nix
    ./hyprland/hyprland.nix
    ./kde.nix
    ./nvidia.nix
    ./studio.nix
    ./system.nix
    ./networking/instant-messangers/discord.nix
    ./zsh.nix

    ../work/knowit.nix
  ];

  config.environment.systemPackages = with pkgs; [
    wl-clipboard
  ];

  config.mystuff = {zsh.enable = true;};
}
