#!/usr/bin/env nix-shell
#!nix-shell -i bash -p alejandra

for i in ./**/*.nix; do
  alejandra "$i"
done

