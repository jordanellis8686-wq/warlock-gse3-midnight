#Requires -Version 5.1
[CmdletBinding()]
param()

$script = Join-Path $PSScriptRoot "..\..\..\scripts\Invoke-ClassThemeInstaller.ps1"
& $script -ClassName 'Warlock' -PrimaryHex '8788EE' -SecondaryHex 'AEEE87' -AccentHex '4E4F96' -LockClassSelection
