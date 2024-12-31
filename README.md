<div align="center">
  <img src=".github/NixOS_logo.svg" alt="NixOS Logo" width="256"/>
</div>

# NixOS Configuration for Joonas Kajava

<p>
  This repository contains the NixOS configuration files for my personal devices.
  This configuration is heavily tied to my personal preferences and workflows, so using it as-is is not recommended.
</p>

## Installation

Clone this repository to `/etc/nixos`.

Execute following command:

```shell
git submodule update --init --recursive
```

Generate hardware configuration:
`nixos-generate-config` after this, you can remove the generated `configuration.nix` file.

Run (replace `nixos-desktop` with the name of the system you want to install):

```shell
sudo nixos-rebuild switch --flake .#nixos-desktop\?submodules=1;
```

After this has been successfully run, you can rebuild the system with just `rebuild` command.
Continue installation according to the ReadMe in the private module.

This repository also contains installation script for windows `win-install.ps1`. This script mainly creates symbolic links to the configuration files in this repository.

## Upgrading and Rebuilding

This configuration adds few aliases to make upgrading and rebuilding easier.

| Command    | Description                                                                          |
| ---------- | ------------------------------------------------------------------------------------ |
| `rebuild`  | Rebuilds the system with the current configuration. Also sources zsh configurations. |
| `upgrade`  | Updates the flake and runs `devenv update`.                                          |
| `optimize` | Removes old NixOS generations, runs garbage collection and deletes old devenvs.      |

## Private Module

Unfortunately, I cannot share all parts of my configuration. This private module contains scripts and configuration to manage secrets in my devices and other work related stuff.
It is **not** necessary to use this module to use the rest of the configuration. Simply remove the import from `flake.nix`.

## Roadmap

This some features I'm planning to add to my configuration.

- [ ] Specify monitors so that flickering doesn't happen on boot. And plymouth splash screen is shown on the correct monitor.
- [ ] Create cli tool / script to read flake input timestamps and compare them with newest version on github. Then output some kind of notification 'nixpkgs-unstable input is 10 days behind.'
  - Maybe display this on the fastfetch output?
- [x] Add some way of managing KDE settings from here, maybe plasma manager?.
  - Currently, this is a bit tricky as KDE settings contain a lot of state information.
- [ ] Add better system wide noise suppression for microphone.
- [ ] Automatic backups for important files.
- [ ] Fix commit signing in git.
- [ ] Experiment with NixOS Specializations.
