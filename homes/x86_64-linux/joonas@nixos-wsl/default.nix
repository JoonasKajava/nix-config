{
  lib,
  config,
  namespace,
  ...
}: {
  programs.jetbrains-remote.enable = true;
  lumi.suites.cli.enable = true;
}
