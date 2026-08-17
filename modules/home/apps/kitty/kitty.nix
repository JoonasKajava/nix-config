{inputs,...}: {
  flake-file.inputs.kitty-themes = {
    url = "github:kovidgoyal/kitty-themes";
    flake = false;
  };
  den.aspects.kitty.homeManager = {
    pkgs,
    ...
  }: {
    fonts.fontconfig.enable = true;
    home.packages = with pkgs.nerd-fonts; [
      fira-mono
    ];

    programs.kitty = {
      enable = true;
      settings = {
        cursor_trail = 3;
        wheel_scroll_multiplier = 0.3;
        touch_scroll_multiplier = 0.3;
        confirm_os_window_close = 0;
        include = "${inputs.kitty-themes}/themes/tokyo_night_moon.conf";
      };
    };
  };
}
