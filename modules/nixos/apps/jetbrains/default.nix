{
  lib,
  pkgs,
  config,
  namespace,
  ...
}:
with lib; let
  cfg = config.${namespace}.apps.jetbrains;
  withPlugins = idePkg: (pkgs.jetbrains.plugins.addPlugins idePkg ["17718"]);
in {
  options.${namespace}.apps.jetbrains = {
    enable = mkEnableOption "Jetbrain products";
    ide = {
      rider = mkEnableOption "JetBrains Rider";
      rust-rover = mkEnableOption "JetBrains Rider";
    };
  };

  config = lib.mkIf cfg.enable {
    snowfallorg.users.${config.${namespace}.user.name}.home.config = {
      ${namespace}.apps.jetbrains.enable = true;
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
          gcc
        ]);

      sessionVariables = lib.mkIf cfg.ide.rider {
        DOTNET_ROOT = "${pkgs.dotnet-sdk}";
      };
    };
  };
}
