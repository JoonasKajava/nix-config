<div align="center">
  <img src=".github/NixOS_logo.svg" alt="NixOS Logo" width="256"/>
</div>

# NixOS Configuration for Joonas Kajava

<p>
  This repository contains the NixOS configuration files for my personal devices.
  This configuration is heavily tied to my personal preferences and workflows, so using it as-is is not recommended.
</p>

## Installation

Run installation script:

> [!CAUTION]
> This script needs to be run as root. Please review the script before running
> it.

```shell
curl https://raw.githubusercontent.com/JoonasKajava/nix-config/refs/heads/master/install.sh | sudo sh
```

Or you can do the manual installation:

Clone this repository to `/etc/nixos`.

Execute following command:

```shell
git submodule update --init --recursive
```

Generate hardware configuration: `nixos-generate-config` after this, you can
remove the generated `configuration.nix` file.

Run (replace `nixos-desktop` with the name of the system you want to install):

```shell
sudo nixos-rebuild switch --flake .#nixos-desktop;
```

After this has been successfully run, you can rebuild the system with just
`rebuild` command. Continue installation according to the ReadMe in the private
module.

This repository also contains installation script for windows `win-install.ps1`.
This script mainly creates symbolic links to the configuration files in this
repository.

## Upgrading and Rebuilding

This configuration adds few aliases to make upgrading and rebuilding easier.

| Command    | Description                                                                          |
| ---------- | ------------------------------------------------------------------------------------ |
| `rebuild`  | Rebuilds the system with the current configuration. Also sources zsh configurations. |
| `upgrade`  | Updates the flake.                                                                   |
| `optimize` | Removes old NixOS generations, runs garbage collection and deletes old devenvs.      |

## Private Module

Unfortunately, I cannot share all parts of my configuration. This private module
contains scripts and configuration to manage secrets in my devices and other
work related stuff. It is **not** necessary to use this module to use the rest
of the configuration. Simply remove the import from `flake.nix`.

## Roadmap

This some features I'm planning to add to my configuration.

- [ ] Specify monitors so that flickering doesn't happen on boot. And plymouth
      splash screen is shown on the correct monitor.
- [ ] Create cli tool / script to read flake input timestamps and compare them
      with newest version on github. Then output some kind of notification
      'nixpkgs-unstable input is 10 days behind.'
  - Maybe display this on the fastfetch output?
- [ ] Fix commit signing in git.
- [ ] Experiment with NixOS Specializations.
- [ ] Use `notify-send` (or similar) to inform about borgmatic backups.
