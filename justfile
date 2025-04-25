rebuild:
    nh os switch --ask .\?submodules=1;
upgrade:
    nix flake update
upgrade-my-configs: 
    nix flake update lumi-private my-nvf
optimize:
    devenv gc; sudo sh -c 'nix-collect-garbage -v -d && nix-store -v --optimize'
