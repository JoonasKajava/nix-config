#! /usr/bin/env nix-shell
#! nix-shell -i nu -p gh git gum nushell

def dry_run_log [message: string] {
    gum log -t rfc822 -s -l info --prefix "Dry Run" $message
}

def log_warn [message: string] {
    gum log -t rfc822 -s -l warn $message
}
def log_info [message: string] {
    gum log -t rfc822 -s -l info $message
}

def safe_mv [
  --dry(-d) # Do not make any changes
  from: string
  to: string
] {
  if ($dry) {
    dry_run_log $"Would move ($from) to ($to)"
  } else if ($from | path exists) {
    log_info $"Moving ($from) to ($to)"
    mv $from $to
  } else {
    log_warn $"Source path ($from) does not exist"
  }
}

def select_folder [
  message: string
  path: string
] {
  let directories = ls $path | where type == "dir" | get name | path parse | get stem
  
  mut selection = ""

  while ($selection == "" or ($path | path join $selection | path exists) == false) {
    $selection = (gum choose ...$directories --header $message)
  }
  return $selection
}

def pretty_print [
  message: string
] {
  gum style --foreground 114 --border-foreground 114 --border double --align center --width 50 --margin "1 2" --padding "2 4" $message
}

def main [
  --dry(-d) # Do not make any changes
] {
  if ($dry) {
    dry_run_log "Running in dry run mode"
  }

  safe_mv --dry=$dry /etc/nixos/configuration.nix ~/configuration.nix.backup
  safe_mv --dry=$dry /etc/nixos/hardware-configuration.nix ~/hardware-configuration.nix.temp

  if ($dry == false) {
    gh auth login -p ssh
  } else  {
    dry_run_log "Would run gh auth login -p ssh"
  }


  if ($dry == false) {
    gh repo clone JoonasKajava/nix-config /etc/nixos/ -- --recurse-submodules
  } else  {
    dry_run_log "Would run gh repo clone JoonasKajava/nix-config /etc/nixos/ -- --recurse-submodules"
  }


  if ($dry == false) {
    cd /etc/nixos/
  } else  {
    dry_run_log "Would run cd /etc/nixos/"
  }

  

  let system = select_folder "Enter which system you want to use:" /etc/nixos/systems
  let hostname = select_folder "Enter which configuration you want to use:" $"/etc/nixos/systems/($system)"

  try {
    gum confirm --default=no $"You have selected ($system) and ($hostname). Do you want to continue?"
  } catch {
    print "Aborting installation"
    exit 
  }

  safe_mv --dry=$dry ~/hardware-configuration.nix.temp $"/etc/nixos/systems/($system)/($hostname)/hardware.nix"

  $env.NIXPKGS_ALLOW_UNFREE = 1

  if ($dry) {
    nix flake check /etc/nixos/
    dry_run_log "Would run gh auth logout"
  } else {
    nixos-rebuild switch --flake $".#($hostname)"
  }

  pretty_print $"Install configuration for ($hostname) complete. Remember to execute setup scripts from private flake."
}
