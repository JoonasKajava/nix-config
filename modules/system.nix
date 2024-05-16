{
  pkgs,
  lib,
  user,
  config,
  ...
}:
with lib; let
  cfg = config.mystuff;
in {
  imports = [../features/programs/neovim/neovim.nix ./audio.nix];

  options.mystuff = {
    nix.gc = {enable = mkEnableOption "Automatic recycling";};
  };

  config = {
    cfg.audio.enable = mkDefault true;

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.${user.username} = {
      isNormalUser = true;
      description = user.name;
      extraGroups = ["networkmanager" "wheel"];
    };

    boot.kernelPackages = pkgs.linuxPackages_latest;

    nix.settings = {experimental-features = ["nix-command flakes"];};
    nix.settings.auto-optimise-store = true;

    nix.gc = {
      automatic = lib.mkDefault true;
      dates = lib.mkDefault "weekly";
      options = lib.mkDefault "--delete-older-than 7d";
    };

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # Set your time zone.
    time.timeZone = "Europe/Helsinki";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "fi_FI.UTF-8";
      LC_IDENTIFICATION = "fi_FI.UTF-8";
      LC_MEASUREMENT = "fi_FI.UTF-8";
      LC_MONETARY = "fi_FI.UTF-8";
      LC_NAME = "fi_FI.UTF-8";
      LC_NUMERIC = "fi_FI.UTF-8";
      LC_PAPER = "fi_FI.UTF-8";
      LC_TELEPHONE = "fi_FI.UTF-8";
      LC_TIME = "fi_FI.UTF-8";
    };

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
      gh
      git
      htop-vim
      tldr
      difftastic
      fastfetch
      rm-improved
      eza
    ];

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Enable sound with pipewire.
    sound.enable = cfg.audio;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };
  };
}
