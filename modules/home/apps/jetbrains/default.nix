{
  lib,
  config,
  pkgs,
  namespace,
  osConfig ? null,
  ...
}: let
  cfg = config.${namespace}.apps.jetbrains;
  rustToolchain = pkgs.rust-bin.stable.latest.default.override {
    extensions = ["rust-src" "clippy" "rustfmt"];
  };
  rust-rover-enabled = osConfig.lumi.apps.jetbrains.ide.rust-rover;
in {
  options.${namespace}.apps.jetbrains = {
    enable = lib.mkEnableOption "Jetbrains";
  };

  config = lib.mkIf cfg.enable {
    home = {
      # packages = lib.optionals rust-rover-enabled [
      #    rustToolchain
      # ];
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
