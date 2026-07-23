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
    ps.setuptools
    ps.graphviz
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
    nixpkgs.config.rocmSupport = true;

    hardware.amdgpu.opencl.enable = true;
    systemd.tmpfiles.rules = let
      rocmEnv = pkgs.symlinkJoin {
        name = "rocm-combined";
        paths = with pkgs.rocmPackages; [
          rocblas
          hipblas
          clr
        ];
      };
    in [
      "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
    ];
    environment.systemPackages = with pkgs; [
      docker-compose
      graphviz
      zoom-us
      vscode
      rocmPackages.rocminfo
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
        kdenlive.enable = true;

        onlyoffice.enable = true;
      };
    };

    networking.networkmanager.plugins = [
      pkgs.networkmanager-openvpn
    ];
  };
}
