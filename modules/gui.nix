{den, ...}: {
  den.aspects.gui = {
    includes = with den.aspects; [
      base
      browsers.vivaldi
      desktop.kde
      easyeffects
      gaming
      gaming.heroic
      hardware.audio
      obsidian
      one-password
      parsec
      vlc

      discord
      ferdium
      kitty
      naps2
    ];
  };
}
