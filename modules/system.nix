{
  pkgs,
  lib,
  user,
  ...
}:
with lib; {
  imports = [./audio.nix];

  options.mystuff = {
    nix.gc = {enable = mkEnableOption "Automatic recycling";};
  };

  config = {
    mystuff = {
      audio.enable = mkDefault true;
      editors = {
        neovim.enable = mkDefault true;
      };
    };
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
      commitizen
    ];

    # Enable CUPS to print documents.
    services.printing.enable = true;
  };
}
