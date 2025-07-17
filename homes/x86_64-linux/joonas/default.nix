{
  lib,
  config,
  namespace,
  host,
  ...
}: let
  inherit (lib) mkIf;
  mkIfHost = list: content: mkIf (builtins.elem host list) content;
in {
  lumi = {
    suites.cli.enable = true;

    apps =
      {
      }
      // mkIfHost ["nixos-desktop" "nixos-laptop"] {
        naps2.enable = true;
        ludusavi.enable = true;

        firefox.enable = true;
        ferdium.enable = true;

        ghostty.enable = false;
      };
  };

  programs.jetbrains-remote.enable = host == "nixos-wsl";
}
