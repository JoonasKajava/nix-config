{
  lib,
  pkgs,
  config,
  namespace,
  ...
}:
with lib; let
  cfg = config.${namespace}.cli.yazi;
in {
  options.${namespace}.cli.yazi = {enable = mkEnableOption "yazi";};

  config = mkIf cfg.enable {
    snowfallorg.users.${config.${namespace}.user.name}.home.config = {
      programs.yazi = {
        enable = true;
        settings = {
          manager = {
            show_hidden = true;
          };
        };
      };

      programs.zsh = mkIf config.${namespace}.cli.zsh.enable {
        initExtra = ''
          function y() {
          	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
          	yazi "$@" --cwd-file="$tmp"
          	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
          		builtin cd -- "$cwd"
          	fi
          	rm -f -- "$tmp"
          }
        '';
      };
    };
  };
}
