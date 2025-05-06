#! /usr/bin/env nix-shell
#! nix-shell -i bash -p gh git

function safe_mv() {
  [ -f "$1" ] && mv "$1" "$2"
}

#######################################
# Creates selection for folder
# Arguments:
#   Message for the selection
#   Where to look for folders
#######################################
function select_folder() {

  if [[ ! -d "$2" ]]; then
    echo "Error: '$2' is not a directory." >&2
    exit 1
  fi

  mapfile -d $'\0' DIRS < <(find "$2" -maxdepth 1 -mindepth 1 -type d -print0)

  if ((${#DIRS[@]} == 0)); then
    echo "No subdirectories found in '$2'." >&2
    exit 1
  fi

  PS3="$1"

  select CHOICE in "${DIRS[@]}"; do
    if [[ -d "$CHOICE" ]]; then
      echo "$CHOICE"
      break
    else
      echo "Invalid choice. Please try again." >&2
    fi
  done
}

printf "Select SSH auth"

safe_mv /etc/nixos/configuration.nix ~/configuration.nix.backup
safe_mv /etc/nixos/hardware-configuration.nix ~/hardware-configuration.nix.temp

gh auth login

gh repo clone JoonasKajava/nix-config /etc/nixos/ -- --recurse-submodules

cd /etc/nixos/ || exit

system=$(select_folder "Enter which system you want to use:" /etc/nixos/systems)
hostname=$(select_folder "Enter which configuration you want to use:" /etc/nixos/systems/"${system}")

safe_mv ~/hardware-configuration.nix.temp /etc/nixos/systems/"${system}"/"${hostname}"/hardware.nix

export NIXPKGS_ALLOW_UNFREE=1

nixos-rebuild switch --flake .#"${hostname}" --experimental-features 'nix-command flakes'

gh auth logout

echo "Install configuration for ${hostname} complete. Remember to execute setup scripts from private flake."
