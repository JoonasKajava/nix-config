param(
    [Parameter(Mandatory = $true)]
    [string]$Source,

    [Parameter(Mandatory = $true)]
    [string]$Target
)

$sourcePath = [IO.Path]::GetFullPath($Source)
$targetPath = [IO.Path]::GetFullPath($Target)
$item = Get-Item -LiteralPath $targetPath -Force -ErrorAction SilentlyContinue

if ($item -and $item.LinkType -eq 'SymbolicLink' -and $item.Target -contains $sourcePath) {
    exit 0
}

if ($item) {
    Remove-Item -LiteralPath $targetPath -Force
}

New-Item -ItemType SymbolicLink -Path $targetPath -Target $sourcePath | Out-Null
Write-Output changed
