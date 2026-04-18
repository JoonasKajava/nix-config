{
  lib,
  pkgs,
  config,
  namespace,
  ...
}:
with lib; let
  cfg = config.${namespace}.school;
  pythonldlibpath = lib.makeLibraryPath (with pkgs; [
    zlib
    zstd
    stdenv.cc.cc
    curl
    openssl
    attr
    libssh
    bzip2
    libxml2
    acl
    libsodium
    util-linux
    xz
    systemd
    mpi
  ]);
  # Darwin requires a different library path prefix
  wrapPrefix =
    if (!pkgs.stdenv.isDarwin)
    then "LD_LIBRARY_PATH"
    else "DYLD_LIBRARY_PATH";

  python = pkgs.python312.withPackages (ps: [
    ps.tkinter
    ps.mpi4py
    ps.scikit-image
    ps.numpy
  ]);

  patchedpython = pkgs.symlinkJoin {
    name = "python";
    paths = [python];
    buildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram "$out/bin/python3.12" --prefix ${wrapPrefix} : "${pythonldlibpath}"
    '';
  };
in {
  options.${namespace}.school = {enable = mkEnableOption "school";};

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      zoom-us
      vscode
      patchedpython
      # (python3.withPackages (p:
      #   with p; [
      #     pytest
      #     numpy
      #     pandas
      #     matplotlib
      #     jupyter
      #   ]))
    ];
    lumi = {
      apps = {
        jetbrains.ide.pycharm = true;
        kdenlive.enable = true;

        onlyoffice.enable = true;
      };
    };

    networking.networkmanager.plugins = [
      pkgs.networkmanager-openvpn
    ];
  };
}
