#!/usr/bin/env nix-shell
#!nix-shell -i bash -p konsave

konsave -s main
mkdir -p /etc/nixos/kde-profiles/main
cp -a ~/.config/konsave/profiles/main /etc/nixos/kde-profiles/main