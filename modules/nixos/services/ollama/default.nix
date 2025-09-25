{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.services.ollama;
in {
  options.${namespace}.services.ollama = {
    enable = mkEnableOption "Whether to enable ollama service";
  };

  config = mkIf cfg.enable {
    services.ollama = {
      enable = true;
      loadModels = ["llama3.2:3b"];
      acceleration = "rocm";
    };
  };
}
