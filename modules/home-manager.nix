{
  config,
  lib,
  user,
  home-manager,
  ...
}:
with lib; let
  cfg = config.mystuff.home-manager;
in {
  options.mystuff.home-manager = {
    enable = mkEnableOption "Enable home manager";
  };

  imports = mkIf cfg.enable [
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = {inherit inputs user;};
      home-manager.users.${user.username} = import ./home;
    }
  ];

  config =
    mkIf cfg.enable {
    };
}
