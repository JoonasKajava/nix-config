

$ideavimrc_source = (Join-Path $PWD features\programs\jetbrains\.ideavimrc)
$ideavimrc_target = (Join-Path $env:USERPROFILE .ideavimrc)
Write-Output "Creating symlink from $ideavimrc_target to $ideavimrc_source"
New-Item -ItemType SymbolicLink -Path $ideavimrc_target -Target $ideavimrc_source