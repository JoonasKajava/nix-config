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
    ide = {
      rider = mkEnableOption "JetBrains Rider";
      rust-rover = mkEnableOption "JetBrains Rider";
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.username} = {config, ...}: {
      home.file.".ideavimrc".source =
        config.lib.file.mkOutOfStoreSymlink
        "/etc/nixos/modules/editors/jetbrains/.ideavimrc";
    };
    environment = {
      systemPackages = with pkgs;
        [
          nodejs
        ]
        ++ lib.optionals cfg.ide.rider (with pkgs; [
          (withPlugins jetbrains.rider)
          dotnet-sdk_8
        ])
        ++ lib.optionals cfg.ide.rust-rover (with pkgs; [
          (withPlugins jetbrains.rust-rover)
          rustup
        ]);

      sessionVariables = lib.mkIf cfg.ide.rider {
        DOTNET_ROOT = "${pkgs.dotnet-sdk}";
      };
    };
  };
}
