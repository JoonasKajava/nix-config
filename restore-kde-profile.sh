#!/usr/bin/env nix-shell
#!nix-shell -i bash -p konsave

cp -a /etc/nixos/kde-profiles/main ~/.config/konsave/profiles
konsave -a main