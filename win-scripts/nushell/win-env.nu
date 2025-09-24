$env.CARAPACE_BRIDGES = "zsh,fish,bash,inshellisense" # optional
mkdir ~/.cache/carapace
carapace _carapace nushell | save --force ~/.cache/carapace/init.nu

zoxide init --cmd cd nushell | save -f ~/.zoxide.nu
