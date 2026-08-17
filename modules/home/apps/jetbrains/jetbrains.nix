{
  inputs,
  ...
}: let
  inherit (inputs.jetbrains-plugins.lib) buildIdeWithPlugins;
  withPlugins = ide: pkgs: (buildIdeWithPlugins pkgs ide ["com.github.copilot"]);
  rustToolchain = pkgs: pkgs.rust-bin.stable.latest.default.override {
    extensions = ["rust-src" "clippy" "rustfmt"];
  };
in {
  flake-file.inputs = {
    jetbrains-plugins = {
      url = "github:nix-community/nix-jetbrains-plugins";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  den.aspects.jetbrains = {
    nixos.nixpkgs.overlays = [
      inputs.rust-overlay.overlays.default
    ];

    rider.homeManager = {pkgs, ...}: {
      home.sessionVariables = {
        DOTNET_ROOT = "${pkgs.dotnet-sdk}";
      };
      home.packages = with pkgs; [
        (withPlugins "rider" pkgs)
        dotnet-sdk_11
        dotnet-ef
      ];
    };

    datagrip.homeManager = {pkgs, ...}: {
      home.packages = [
        (withPlugins "datagrip" pkgs)
      ];
    };

    webstorm.homeManager = {pkgs, ...}: {
      home.packages = [
        (withPlugins "webstorm" pkgs)
      ];
    };

    pycharm.homeManager = {pkgs, ...}: {
      home.packages = [
        (withPlugins "pycharm" pkgs)
      ];
    };
    rust-rover.homeManager = {pkgs, ...}: {
      home = {
        packages = with pkgs; [
          (withPlugins "rust-rover" pkgs)
          gcc
        ];
      };
      file = {
        ".rust-rover/toolchain/bin".source = "${rustToolchain pkgs}/bin";

        ".rust-rover/toolchain/lib".source = "${rustToolchain pkgs}/lib";
      };
    };

    homeManager = {
      pkgs,
      config,
      ...
    }: {
      home.packages = [pkgs.nodejs];
      home.file = {
        ".ideavimrc".source =
          config.lib.file.mkOutOfStoreSymlink
          "/etc/nixos/modules/home/apps/jetbrains/.ideavimrc";
      };
    };
  };
}
