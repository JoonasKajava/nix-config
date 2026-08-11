  {
    den.aspects.maccel.nixos = {
      # For custom mouse acceleration curves
      hardware.maccel = {
        enable = true;
        enableCli = true;
        parameters = {
          mode = "linear";
          sensMultiplier = 1.0;
          acceleration = 0.1;
          offset = 10.0;
          outputCap = 2.0;
        };
      };
    };
  }
