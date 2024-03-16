#!/usr/bin/env nix-shell
#!nix-shell -i bash -p konsave

rsync -a --delete /etc/nixos/kde-profiles/main ~/.config/konsave/profiles/main
konsave -a main