#!/usr/bin/env nix-shell
#!nix-shell -p konsave

konsave -s main
cp -a ~/.config/konsave/profiles/main /etc/nixos/kde-profiles/main