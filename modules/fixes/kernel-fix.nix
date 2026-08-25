{inputs, ...}: {
  flake-file.inputs = {
    kernel-fix.url = "github:nixos/nixpkgs/104240a772428cc2e20d8fd86c9ddbb886bbaff2";
  };
  # den.default = {
  #   nixos = {pkgs, ...}: {
  #     # TODO: Downgrade to 7.1.5 kernel to fix gpu artifacting
  #     boot.kernelPackages = inputs.kernel-fix.legacyPackages.${pkgs.system}.linuxPackages_latest;
  #   };
  # };
}
