#! /usr/bin/env nix-shell
#! nix-shell -i nu -p git nushell

def notify [
  topic: string,
  title: string
  message: string,
  priority: string,
  tags: list<string>
] {
    (http post
    --headers {
      Title: $title
      Priority: $priority
      Tags: ($priority | str join ",")
    }
    $"ntfy.joonaskajava.com/($topic)" $message)
}

cd /etc/nixos;

let hostname = (sys host).hostname

try {
  if (git status --porcelain | length) {
    notify "nixos-system" "Automatic Rebuilding Aborted" "There are uncommitted changes in the NixOS configuration. Please commit or stash them before running the auto-rebuild script." "high" ["rotating_light"];
    exit;
  }

  git pull;
  
  nix-rebuild switch;

  notify "nixos-system" "Automatic Rebuilding Succefull" $"($hostname) just performed automatic rebuild successfully." "default" ["white_check_mark"];
} catch { |err|
  notify "nixos-system" "Automatic Rebuilding Aborted" $"Unable to automatically rebuild the system due: ($err.msg)" "high" ["rotating_light"];
};
