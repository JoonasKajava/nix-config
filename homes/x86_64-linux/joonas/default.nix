{
  lib,
  host,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  mkIfHost = list: content: mkIf (builtins.elem host list) content;
in {
  lumi = {
    suites.cli.enable = true;

    services = {
      syncthing.enable = true;
    };

    apps = lib.${namespace}.recursiveMerge [
      (mkIfHost
        ["nixos-desktop"]
        {
          obs-studio.enable = true;
        })
      (mkIfHost
        ["nixos-desktop" "nixos-laptop"]
        {
          naps2.enable = true;
          ludusavi.enable = true;

          firefox.enable = true;
          ferdium.enable = true;
          vscode.enable = true;

          ghostty.enable = false;
          
          anki.enable = true;
        })
    ];
  };

  programs.jetbrains-remote.enable = host == "nixos-wsl";
}
