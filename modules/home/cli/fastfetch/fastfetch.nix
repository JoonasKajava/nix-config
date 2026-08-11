{
  flake-file.inputs.system-age = {
    url = "git+ssh://git@github.com/JoonasKajava/system-age";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.cli.homeManager = {lib, inputs, system, ...}: {
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
