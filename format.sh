#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nixfmt

for i in ./**/*.nix; do
  nixfmt "$i"
done

