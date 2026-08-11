{
  den.aspects.firefox.homeManager = {pkgs, ...}: {
    home.packages = with pkgs; [
      firefoxpwa
    ];

    programs.firefox = {
      enable = true;
      nativeMessagingHosts = [pkgs.firefoxpwa];
      languagePacks = ["fi" "en"];
    };
  };
}
