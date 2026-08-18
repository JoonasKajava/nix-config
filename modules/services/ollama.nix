{
  den.aspects.ollama = {
    nixos = {pkgs, ...}: {
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
  };
}
