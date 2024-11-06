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
    ./brave.nix
    ./gaming/mangohud.nix
    ./gaming/warhammer.nix
    ./gaming/lutris.nix
    ./gnome.nix
    ./hyprland/hyprland.nix
    ./kde.nix
    ./nvidia.nix
    ./studio.nix
    ./system.nix
    ./networking/instant-messangers/discord.nix
    ./virtualization/virtualization.nix
    ./zsh.nix
    ./yazi.nix

    ../work/knowit.nix
  ];

  config.environment.systemPackages = with pkgs; [
    wl-clipboard
  ];

  config.mystuff = {zsh.enable = true;};
}
