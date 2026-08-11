{
  den.aspects.vscode.homeManager = {pkgs, ...}: {
    programs.vscode = {
      enable = true;
      package = pkgs.vscode.fhs;
    };
  };
}
