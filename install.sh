#! /usr/bin/env nix-shell
#! nix-shell -i bash -p gh git

printf "Select SSH auth"

gh auth login

gh repo clone JoonasKajava/nix-config /etc/nixos/ -- --recurse-submodules

cd /etc/nixos/ || exit

printf "Enter which configuration you want to use:"
read -r hostname

printf "Enter the system architecture for this host (eg. \'x86_64-linux\')"
read -r system

rm /etc/nixos/configuration.nix
rm /etc/nixos/hardware-configuration.nix /etc/nixos/systems/"${system}"/"${hostname}"/hardware.nix

export NIXPKGS_ALLOW_UNFREE=1

nixos-rebuild switch --flake .#"${hostname}" --experimental-features 'nix-command flakes'

gh auth logout

echo "Install configuration for ${hostname} complete. Remember to execute setup scripts from private flake."
