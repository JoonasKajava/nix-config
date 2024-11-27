{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.mystuff.editors.jetbrains;
  addIDE = idePkg: pkgs.jetbrains.plugins addPlugins idePkg ["github-copilot"];
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
        (addIDE jetbrains.rider)
        dotnet-sdk_8
        nodejs_22
      ];
      sessionVariables = {
        DOTNET_ROOT = "${pkgs.dotnet-sdk}";
      };
    };
  };
}
