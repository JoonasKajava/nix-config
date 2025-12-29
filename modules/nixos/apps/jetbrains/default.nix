{
  lib,
  pkgs,
  config,
  namespace,
  inputs,
  system,
  ...
}:
with lib; let
  cfg = config.${namespace}.apps.jetbrains;
  inherit (inputs.jetbrains-plugins.lib."${system}") buildIdeWithPlugins;
  withPlugins = ide: (buildIdeWithPlugins pkgs.jetbrains ide ["com.github.copilot"]);
in {
  options.${namespace}.apps.jetbrains = {
    enable = mkEnableOption "Jetbrain products";
    ide = {
      rider = mkEnableOption "JetBrains Rider";
      rust-rover = mkEnableOption "JetBrains Rider";
      datagrip = mkEnableOption "JetBrains DataGrip";
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
        ++ lib.optionals cfg.ide.datagrip [
          (withPlugins "datagrip")
        ]
        ++ lib.optionals cfg.ide.rider (with pkgs; [
          (withPlugins "rider")
          dotnet-sdk_8
        ])
        ++ lib.optionals cfg.ide.rust-rover (with pkgs; [
          (withPlugins "rust-rover")
          rustup
          gcc
        ]);

      sessionVariables = lib.mkIf cfg.ide.rider {
        DOTNET_ROOT = "${pkgs.dotnet-sdk}";
      };
    };
  };
}
