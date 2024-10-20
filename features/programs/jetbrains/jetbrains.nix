{
  pkgs,
  lib,
  user,
  ...
}: {
  home-manager.users.${user.username} = {config, ...}: {
    home.file.".ideavimrc".source =
      config.lib.file.mkOutOfStoreSymlink
      "/etc/nixos/features/programs/jetbrains/.ideavimrc";
  };

  environment.systemPackages = with pkgs.jetbrains; [rider];
}
