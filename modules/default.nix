{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./audio/easyeffects.nix
    ./brave.nix
    ./editors/neovim/neovim.nix
    ./editors/jetbrains/jetbrains.nix
    ./firefox.nix
    ./gaming/lutris.nix
    ./gaming/mangohud.nix
    ./gaming/warhammer.nix
    ./gaming/steam.nix
    ./gaming/heroic.nix
    ./gnome.nix
    ./hyprland/hyprland.nix
    ./kde.nix
    ./misc/1password.nix
    ./networking/instant-messangers/discord.nix
    ./networking/remote/freerdp.nix
    ./nvidia.nix
    ./office/obsidian.nix
    ./studio.nix
    ./system.nix
    ./terminal/kitty.nix
    ./terminal/tmux.nix
    ./terminal/zellij.nix
    ./virtualization/virtualization.nix
    ./yazi.nix
    ./zsh.nix
    ./printing.nix
    ./os/plymouth.nix
    ./plasma-manager/plasma-manager.nix
  ];

  config.environment.systemPackages = with pkgs; [
    wl-clipboard
  ];

  config.mystuff = {
    zsh.enable = true;
  };
}
