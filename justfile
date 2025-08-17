rebuild:
    nh os switch --ask .\?submodules=1;
rebuild-boot:
    sudo nixos-rebuild boot
upgrade:
    nix flake update
upgrade-my-configs: 
    nix flake update lumi-private my-nvf system-age
optimize:
    devenv gc; sudo sh -c 'nix-collect-garbage -v -d && nix-store -v --optimize'
mount-latest-backup:
    sudo mkdir -p /mnt/backup; sudo borgmatic mount --archive latest --mount-point /mnt/backup
unmount-latest-backup:
    sudo borgmatic umount --mount-point /mnt/backup
manual-backup:
    sudo borgmatic create --verbosity 1 --list --stats
