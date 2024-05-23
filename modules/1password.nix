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

    home.sessionVariables = {SSH_AUTH_SOCK = onePassSock;};

    programs._1password.enable = true;
    programs._1password-gui = {
      enable = true;
      polkitPolicyOwners = [user.username];
    };

    programs.ssh = {
      enable = true;
      extraOptionOverrides = {IdentityAgent = onePassPath;};
      extraConfig = ''
        Host *
                  IdentitiesOnly=yes
                  IdentityAgent ${onePassPath}
      '';
    };
  };
}
