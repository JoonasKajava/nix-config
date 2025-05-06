#! /usr/bin/env nix-shell
#! nix-shell -i bash -p gh git

gh auth login

gh repo clone JoonasKajava/nix-config /etc/nixos/

cd /etc/nixos/

git submodule update --init --recursive

echo "Enter which configuration you want to use:"
read hostname

echo "Enter the system architecture for this host (eg. \'x86_64-linux\')"
read system

nixos-generate-config --show-hardware-config >/etc/nixos/systems/${system}/${hostname}/hardware.nix

rm /etc/nixos/configuration.nix
rm /etc/nixos/hardware-configuration.nix

export NIXPKGS_ALLOW_UNFREE=1

nixos-rebuild switch --flake .#${hostname} --experimental-features 'nix-command flakes'

gh auth logout

echo "Install configuration for ${hostname} complete. Remember to execute setup scripts from private flake."
