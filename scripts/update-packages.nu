let system = (nix eval --impure --raw --expr builtins.currentSystem)

let packages = (
    nix eval $".#packages.($system)"
        --apply builtins.attrNames
        --json
    | from json
)

for package in $packages {
    print $"Updating ($package)..."
    # nix run nixpkgs#nix-update -- --flake $package
}
