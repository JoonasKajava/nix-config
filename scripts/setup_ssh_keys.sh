#! /usr/bin/env nix-shell
#! nix-shell -i bash -p _1password

export_key() {
  echo "Exporting public key $1 to $2.pub"
  op read "op://Private/$1/public key" >~/.ssh/"$2".pub
  echo "Exporting private key $1 to $2"
  op read "op://Private/$1/private key" >~/.ssh/"$2"
}

export_key "Github - Joonas Kajava" "github"
export_key "BorgBase - SSH Key" "borg"
export_key "DevOps" "azure"
