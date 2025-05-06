rebuild:
    nh os switch --ask .\?submodules=1;
rebuild-boot:
    sudo nixos-rebuild boot
upgrade:
    nix flake update
upgrade-my-configs: 
    nix flake update lumi-private my-nvf
optimize:
    devenv gc; sudo sh -c 'nix-collect-garbage -v -d && nix-store -v --optimize'
edit-sops:
    sops nix-config-private/modules/nixos/services/sops/secrets/joonas.yaml
