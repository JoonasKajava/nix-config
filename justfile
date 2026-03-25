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
mount-backup archive='latest':
    sudo mkdir -p /mnt/backup; sudo borgmatic mount --archive {{archive}} --mount-point /mnt/backup
unmount-backup:
    sudo borgmatic umount --mount-point /mnt/backup
manual-backup:
    sudo borgmatic create --verbosity 1 --list --stats
