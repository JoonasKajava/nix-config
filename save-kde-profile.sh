#!/usr/bin/env nix-shell
#!nix-shell -i bash -p konsave

konsave -s main -f
mkdir -p /etc/nixos/kde-profiles
cp -a ~/.config/konsave/profiles/main /etc/nixos/kde-profiles