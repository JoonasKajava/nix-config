[CmdletBinding()]
param(
    [string]$ConfigurationPath = (Join-Path $PSScriptRoot 'install-config.json')
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $ConfigurationPath -PathType Leaf)) {
    throw "Configuration file not found: $ConfigurationPath"
}

$configurationDirectory = Split-Path -Parent (Resolve-Path -LiteralPath $ConfigurationPath)
$tools = @(Get-Content -LiteralPath $ConfigurationPath -Raw | ConvertFrom-Json)

foreach ($tool in $tools) {
    if ([string]::IsNullOrWhiteSpace($tool.name)) {
        throw 'Every configuration entry must have a name.'
    }

    if (-not [string]::IsNullOrWhiteSpace($tool.installScript)) {
        Write-Output "Installing $($tool.name)"
        & $env:ComSpec /d /c $tool.installScript
        if ($LASTEXITCODE -ne 0) {
            throw "Installation failed for $($tool.name) with exit code $LASTEXITCODE."
        }
    }

    foreach ($symlink in @($tool.symlinks)) {
        $source = [Environment]::ExpandEnvironmentVariables($symlink.source)
        $target = [Environment]::ExpandEnvironmentVariables($symlink.target)

        if (-not [IO.Path]::IsPathRooted($source)) {
            $source = Join-Path $configurationDirectory $source
        }

        if (-not (Test-Path -LiteralPath $source)) {
            throw "Symlink source not found for $($tool.name): $source"
        }

        $targetDirectory = Split-Path -Parent $target
        if ($targetDirectory) {
            New-Item -ItemType Directory -Path $targetDirectory -Force | Out-Null
        }

        Write-Output "Linking $target to $source"
        & (Join-Path $PSScriptRoot 'New-Symlink.ps1') -Source $source -Target $target
    }
}
