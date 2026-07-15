{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.services.ollama;
in {
  options.${namespace}.services.ollama = {
    enable = mkEnableOption "Whether to enable ollama service";
  };

  config = mkIf cfg.enable {
    services = {
      open-webui.enable = true;
      open-webui.package = pkgs.stable.open-webui;
      ollama = {
        package = pkgs.ollama-rocm;
        enable = true;
        loadModels = ["qwen3.5:9b"];
        syncModels = true;
      };
    };
  };
}
