{
  config,
  lib,
  user,
  ...
}:
with lib; let
  cfg = config.mystuff.onepassword;
  onePassSock = "~/.1password/agent.sock";
in {
  options.mystuff.onepassword = {
    enable = mkEnableOption "1 password";
  };

  config = mkIf cfg.enable {
    environment.variables = {SSH_AUTH_SOCK = onePassSock;};

    programs._1password.enable = true;
    programs._1password-gui = {
      enable = true;
      polkitPolicyOwners = [user.username];
    };

    services.gnome.gnome-keyring.enable = true;

    home-manager.users.${user.username} = {config, ...}: {
      home.file.".config/1Password/ssh/agent.toml" = {
        source =
          config.lib.file.mkOutOfStoreSymlink
          "/etc/nixos/modules/misc/agent.toml";
      };

      home.sessionVariables = {SSH_AUTH_SOCK = onePassSock;};
      programs.ssh = {
        enable = true;
        extraOptionOverrides = {IdentityAgent = onePassSock;};
        extraConfig = ''
          Host github
              HostName github.com
              User JoonasKajava
              IdentityFile ~/.ssh/github.pub
              IdentitiesOnly yes
          Host *
              IdentityAgent ${onePassSock}
        '';
      };
    };
  };
}
