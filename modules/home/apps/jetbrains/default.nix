{
  lib,
  config,
  pkgs,
  namespace,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption;
  cfg = config.${namespace}.apps.jetbrains;
  inherit (inputs.jetbrains-plugins.lib) buildIdeWithPlugins;
  withPlugins = ide: (buildIdeWithPlugins pkgs ide ["com.github.copilot"]);
  rustToolchain = pkgs.rust-bin.stable.latest.default.override {
    extensions = ["rust-src" "clippy" "rustfmt"];
  };
  rust-rover-enabled = cfg.enable && cfg.ide.rust-rover;
in {
  options.${namespace}.apps.jetbrains = {
    enable = lib.mkEnableOption "Jetbrains";
    ide = {
      rider = mkEnableOption "JetBrains Rider";
      rust-rover = mkEnableOption "JetBrains Rider";
      datagrip = mkEnableOption "JetBrains DataGrip";
      pycharm = mkEnableOption "JetBrains PyCharm";
      webstorm = mkEnableOption "JetBrains Webstorm";
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      sessionVariables = lib.mkIf cfg.ide.rider {
        DOTNET_ROOT = "${pkgs.dotnet-sdk}";
      };
      packages = with pkgs;
        [
          nodejs
        ]
        ++ lib.optionals cfg.ide.datagrip [
          (withPlugins "datagrip")
        ]
        ++ lib.optionals cfg.ide.webstorm [
          (withPlugins "webstorm")
        ]
        ++ lib.optionals cfg.ide.pycharm [
          (withPlugins "pycharm")
        ]
        ++ lib.optionals cfg.ide.rider (with pkgs; [
          (withPlugins "rider")
          dotnet-sdk_11
          dotnet-ef
        ])
        ++ lib.optionals cfg.ide.rust-rover (with pkgs; [
          (withPlugins "rust-rover")
          gcc
        ]);
      file = {
        ".ideavimrc".source =
          config.lib.file.mkOutOfStoreSymlink
          "/etc/nixos/modules/home/apps/jetbrains/.ideavimrc";

        ".rust-rover/toolchain/bin" = lib.mkIf rust-rover-enabled {source = "${rustToolchain}/bin";};

        ".rust-rover/toolchain/lib" = lib.mkIf rust-rover-enabled {source = "${rustToolchain}/lib";};
      };
    };
  };
}
