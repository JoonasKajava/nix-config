{
  lib,
  host,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) useVivaldi;
  mkIfHost = list: content: mkIf (builtins.elem host list) content;
in {
  lumi = {
    suites.cli.enable = true;

    cli.zellij.enableNushellIntegration = builtins.elem host ["nixos-desktop" "nixos-laptop"];

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

          #firefox.enable = true;
          vivaldi.enable = useVivaldi;

          ferdium.enable = true;
          vscode.enable = true;

          discord.enable = true;

          # laggy for some reason
          ghostty.enable = false;
          kitty.enable = true;
        })
    ];
  };

  programs.jetbrains-remote.enable = host == "nixos-wsl";
}
