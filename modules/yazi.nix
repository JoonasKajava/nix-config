{
  config,
  lib,
  user,
  inputs,
  ...
}:
with lib; let
  cfg = config.mystuff.yazi;
in {
  options.mystuff.yazi = {
    enable = mkEnableOption "yazi";
  };

  config = mkIf cfg.enable {
    programs.yazi = {
      enable = true;
      #TODO use stable for now. Can switch when build works
      package = inputs.nixpkgs-stable.yazi;
    };

    home-manager.users.${user.username} = {
      programs.zsh = {
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
