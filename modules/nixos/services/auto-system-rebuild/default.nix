{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.services.auto-system-rebuild;

  rebuildScript =
    pkgs.writeScriptBin "rebuild-script.nu"
    # nu
    ''
      def notify [
        title: string,
        message: string,
        priority: string,
        tags: string
      ] {
          let token = cat ${config.sops.secrets.ntfy-token.path}
          http post --user "" --password $token --headers { Title: $title Priority: $priority Tags: $tags } $"https://ntfy.joonaskajava.com/nixos-system" $message
      }

      let hostname = (sys host).hostname

      try {

        nixos-rebuild switch --flake github:JoonasKajava/nix-config#nixos-server

        notify "Automatic Rebuilding Successful" $"($hostname) just performed automatic rebuild successfully." "default" "white_check_mark";
      } catch { |err|
        notify "Automatic Rebuilding Aborted" $"($hostname) had to abort rebuild due: ($err.rendered | ansi strip)" "high" "rotating_light";
      };
    '';
in {
  options.${namespace}.services.auto-system-rebuild = {
    enable = mkEnableOption "Whether to enable automatic system rebuilding";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      rebuildScript
    ];

    # Cannot get this working, use system.autoUpgrade.flake
    # Use OnFailure and OnSuccess to notify about rebuilds
    systemd = {
      timers.auto-system-rebuild = {
        wantedBy = ["timers.target"];
        timerConfig = {
          OnCalendar = "weekly";
          Persistent = true;
        };
      };
      services.auto-system-rebuild = {
        script = "${pkgs.nushell}/bin/nu ${rebuildScript}/bin/rebuild-script.nu";
        after = ["sops-nix.service"];
        environment = {
          GIT_SSH_COMMAND = "ssh -i ${config.sops.secrets."ssh/github".path}";
        };
        path = with pkgs; [
          nixos-rebuild
          coreutils
          gnutar
          xz.bin
          gzip
          gitMinimal
          config.nix.package.out
          config.programs.ssh.package
        ];
        serviceConfig = {
          Type = "oneshot";
          User = "root";
        };
      };
    };
  };
}
