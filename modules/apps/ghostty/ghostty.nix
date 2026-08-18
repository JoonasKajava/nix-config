{
  den.aspects.ghostty.homeManager = {pkgs, ...}: {
    fonts.fontconfig.enable = true;
    home.packages = with pkgs.nerd-fonts; [
      fira-mono
    ];
    programs.ghostty = {
      enable = true;
      settings = {
        font-family = "FiraMono Nerd Font Mono";
        mouse-scroll-multiplier = 0.3;
        theme = "TokyoNight Moon";
        custom-shader = [
          "${./shaders/cursor_smear.glsl}"
        ];
      };
    };
  };
}
