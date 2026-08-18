{
  den,
  inputs,
  ...
}: {
  den.aspects.cli.includes = [
    den.aspects.neovim.nvf
  ];

  flake-file.inputs = {
    my-nvf = {
      url = "github:JoonasKajava/nvf-config";
    };
  };

  den.aspects.neovim.nvf.nixos = {
    system,
    ...
  }: {
    environment = {
      systemPackages = [
        inputs.my-nvf.packages.${system}.default
      ];

      variables.EDITOR = "nvim";
    };
  };
}
