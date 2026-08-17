{
  inputs,
  pkgs,
  ...
}: let
  inherit (inputs.jetbrains-plugins.lib) buildIdeWithPlugins;
  withPlugins = ide: (buildIdeWithPlugins pkgs ide ["com.github.copilot"]);
  rustToolchain = pkgs.rust-bin.stable.latest.default.override {
    extensions = ["rust-src" "clippy" "rustfmt"];
  };
in {
  flake-file.inputs = {
    jetbrains-plugins = {
      url = "github:nix-community/nix-jetbrains-plugins";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.aspects.jetbrains = {
    rider.homeManager = {pkgs, ...}: {
      home.sessionVariables = {
        DOTNET_ROOT = "${pkgs.dotnet-sdk}";
      };
      home.packages = with pkgs; [
        (withPlugins "rider")
        dotnet-sdk_11
        dotnet-ef
      ];
    };

    datagrip.homeManager = {pkgs, ...}: {
      home.packages = [
        (withPlugins "datagrip")
      ];
    };

    webstorm.homeManager = {pkgs, ...}: {
      home.packages = [
        (withPlugins "webstorm")
      ];
    };

    pycharm.homeManager = {pkgs, ...}: {
      home.packages = [
        (withPlugins "pycharm")
      ];
    };
    rust-rover.homeManager = {pkgs, ...}: {
      home = {
        packages = with pkgs; [
          (withPlugins "rust-rover")
          gcc
        ];
      };
      file = {
        ".rust-rover/toolchain/bin".source = "${rustToolchain}/bin";

        ".rust-rover/toolchain/lib".source = "${rustToolchain}/lib";
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
