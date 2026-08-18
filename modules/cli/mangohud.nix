{
  den.aspects.gaming = {
    homeManager = {pkgs, ...}: {
      home.packages = with pkgs; [
        mangohud
      ];
      programs.mangohud = {
        enable = true;
        settings = {
          gpu_stats = true;
          gpu_temp = true;

          cpu_stats = true;
          cpu_temp = true;

          io_read = true;

          vram = true;
          fps_metrics = "avg,0.01,0.001";
        };
      };
    };
  };
}
