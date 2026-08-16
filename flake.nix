# DO-NOT-EDIT. This file was auto-generated using github:vic/flake-file.
# Use `nix run .#write-flake` to regenerate it.
{

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

  inputs = {
    catppuccin.url = "github:catppuccin/nix";
    configA.url = "github:JoonasKajava/nix-config";
    configB.url = "github:JoonasKajava/nix-config?ref=dendritic";
    den.url = "github:denful/den";
    flake-file.url = "github:vic/flake-file";
    flake-parts = {
      inputs.nixpkgs-lib.follows = "nixpkgs-lib";
      url = "github:hercules-ci/flake-parts";
    };
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager";
    };
    import-tree.url = "github:vic/import-tree";
    jetbrains-plugins = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/nix-jetbrains-plugins";
    };
    kitty-themes = {
      flake = false;
      url = "github:kovidgoyal/kitty-themes";
    };
    lanzaboote = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/lanzaboote";
    };
    maccel.url = "github:Gnarus-G/maccel";
    my-nvf.url = "github:JoonasKajava/nvf-config";
    nix-config-private = {
      flake = false;
      url = "git+ssh://git@github.com/JoonasKajava/nix-config-private?ref=den";
    };
    nix-index-database = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/nix-index-database";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-lib.follows = "nixpkgs";
    plasma-manager = {
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:nix-community/plasma-manager";
    };
    sops-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:Mic92/sops-nix";
    };
    stylix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/stylix";
    };
    system-age = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "git+ssh://git@github.com/JoonasKajava/system-age";
    };
    vim-zellij-navigator = {
      flake = false;
      url = "https://github.com/hiasr/vim-zellij-navigator/releases/latest/download/vim-zellij-navigator.wasm";
    };
  };

}
