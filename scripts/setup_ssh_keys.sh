#! /usr/bin/env nix-shell
#! nix-shell -i bash -p _1password

export_public_key(name) {
        op read "op://Private/Github - Joonas Kajava/public key" > ~/.ssh/github.pub;
}


