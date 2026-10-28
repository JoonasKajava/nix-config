{
  den.aspects.cli.homeManager = {
    programs.television = {
      enable = true;
      enableNushellIntegration = true;
      settings = {
        shell_integration.channel_triggers = {
          dirs = ["cd" "ls" "rmdir"];
          files = ["mv" "cp" "nvim" "vim" "sops"];
        };
      };
    };
    programs.nushell.extraConfig =
      # nu
      ''
        def "nu-complete tv channels" [] {
            ^tv list-channels | lines | str trim | where {|name| $name != ""} | append [
                "list-channels"
                "init"
                "completions"
                "update-channels"
                "migrate-config"
                "help"
            ]
            | uniq
        }

        extern tv [
            channel?: string@"nu-complete tv channels"
            ...args: string
        ]
      '';
  };
}
