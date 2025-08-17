{
  lib,
  config,
  inputs,
  namespace,
  system,
  ...
}: let
  cfg = config.${namespace}.cli.fastfetch;

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
            text = "${lib.getExe inputs.system-age.packages.${system}.default} -e";
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
