rebuild:
    nh os switch --ask .\?submodules=1; source ~/.zshenv; source ~/.zshrc
upgrade input='':
    nix flake update {{input}}
upgrade-nvf: 
  just upgrade my-nvf
upgrade-private: 
  just upgrade lumi-private
optimize:
    devenv gc; sudo sh -c 'nix-collect-garbage -v -d && nix-store -v --optimize'
