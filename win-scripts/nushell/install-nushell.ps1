if(!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList "-File `"$($MyInvocation.MyCommand.Path)`"  `"$($MyInvocation.MyCommand.UnboundArguments)`""
    Exit
}

winget install ajeetdsouza.zoxide

winget install nushell
winget install -e --id rsteube.Carapace

# Install Yazi
winget install sxyazi.yazi
winget install Gyan.FFmpeg 7zip.7zip jqlang.jq sharkdp.fd BurntSushi.ripgrep.MSVC junegunn.fzf ajeetdsouza.zoxide ImageMagick.ImageMagick

winget install starship

function Sym-Link
{
    param (
        [string]$source,
        [string]$target
    )
    Write-Output "Creating symlink from $source to $target"
    New-Item -ItemType SymbolicLink -Path $target -Target $source -Force
}

Sym-Link (Join-Path $PSScriptRoot win-config.nu) (Join-Path $env:APPDATA nushell\config.nu)

Sym-Link (Join-Path $PSScriptRoot win-env.nu) (Join-Path $env:APPDATA nushell\env.nu)

Sym-Link (Join-Path $PSScriptRoot win-starship.toml) (Join-Path $HOME .config\starship.toml)

Read-Host -Prompt "Press Enter to exit"
