{
  lib,
  pkgs,
  config,
  namespace,
  ...
}:
with lib; let
  cfg = config.${namespace}.cli.mangohud;
in {
  options.${namespace}.cli.mangohud = {enable = mkEnableOption "mangohud";};

  config = mkIf cfg.enable {
    #
    # Add mangohud %command% to steam launch options

    environment.systemPackages = with pkgs; [
      mangohud
    ];

    snowfallorg.users.${config.${namespace}.user.name}.home.config = {
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
