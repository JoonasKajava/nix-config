{
  lib,
  config,
  pkgs,
  namespace,
  ...
}: let
  cfg = config.${namespace}.cli.fastfetch;

  birthScript = pkgs.writeShellScriptBin "birth.nu" ''
    #! nix-shell -i nu -p nushell
    stat /etc/nixos/ | lines | parse "{key}: {value}" | str trim | where key == "Birth" | get 0.value | into datetime
  '';
in {
  options.${namespace}.cli.fastfetch = {
    enable = lib.mkEnableOption "fastfetch";
  };
  config = lib.mkIf cfg.enable {
    programs.fastfetch = {
      enable = true;
      settings = {
        modules = [
          "title"
          "separator"
          "os"
          "host"
          "kernel"
          {
            type = "command";
            text = "nix-shell ${lib.getExe birthScript}";
            key = "Birth";
          }
          "uptime"
          "packages"
          "shell"
          "display"
          "de"
          "wm"
          "wmtheme"
          "theme"
          "icons"
          "font"
          "cursor"
          "terminal"
          "terminalfont"
          "cpu"
          "gpu"
          "memory"
          "swap"
          "disk"
          "localip"
          "battery"
          "poweradapter"
          "locale"
          "break"
          "colors"
        ];
      };
    };
  };
}
