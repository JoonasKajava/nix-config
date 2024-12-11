{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.mystuff.editors.jetbrains;
  withPlugins = idePkg: (pkgs.jetbrains.plugins.addPlugins idePkg ["17718"]);
in {
  options.mystuff.editors.jetbrains = {
    enable = mkEnableOption "jetbrains products";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.username} = {config, ...}: {
      home.file.".ideavimrc".source =
        config.lib.file.mkOutOfStoreSymlink
        "/etc/nixos/modules/editors/jetbrains/.ideavimrc";
    };
    environment = {
      systemPackages = with pkgs; [
        (withPlugins jetbrains.rider)
        (withPlugins jetbrains.rust-rover)
        dotnet-sdk_8
        nodejs
      ];
      sessionVariables = {
        DOTNET_ROOT = "${pkgs.dotnet-sdk}";
      };
    };
  };
}
