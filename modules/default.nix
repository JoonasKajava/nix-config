{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./audio/easyeffects.nix
    ./bazecor.nix
    ./brave.nix
    ./devices/kdeconnect.nix
    ./editors/jetbrains/jetbrains.nix
    ./editors/neovim/neovim.nix
    ./firefox.nix
    ./gaming/heroic.nix
    ./gaming/lutris.nix
    ./gaming/mangohud.nix
    ./gaming/steam.nix
    ./gaming/warhammer.nix
    ./gnome.nix
    ./hyprland/hyprland.nix
    ./kde.nix
    ./misc/1password.nix
    ./networking/instant-messangers/discord.nix
    ./networking/remote/freerdp.nix
    ./nvidia.nix
    ./office/obsidian.nix
    ./os/plymouth.nix
    ./plasma-manager/plasma-manager.nix
    ./printing.nix
    ./studio.nix
    ./system.nix
    ./terminal/kitty.nix
    ./terminal/tmux.nix
    ./terminal/zellij.nix
    ./virtualization/virtualization.nix
    ./yazi.nix
    ./zsh.nix
    ./vlc.nix
  ];

  config.environment.systemPackages = with pkgs; [
    wl-clipboard
  ];

  config.mystuff = {
    zsh.enable = true;
  };
}
