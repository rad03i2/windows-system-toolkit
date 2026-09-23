[CmdletBinding()]
param(
 [ValidateSet('system','storage','large-files','cleanup-preview','export')][string]$Command='system',
 [string]$Path='.', [string]$MinimumSize='500MB', [int]$Top=25, [int]$OlderThanDays=7,
 [switch]$Json, [switch]$Version
)
$ErrorActionPreference='Stop'
Import-Module (Join-Path $PSScriptRoot 'WindowsSystemToolkit.psm1') -Force
if($Version){'Windows System Toolkit 1.0.0 — Radwan Abdulhadi Ahmed / @rad03i2'; exit 0}
try {
 switch($Command){
  'system' {$result=Get-WstSystemReport}
  'storage' {$result=@(Get-WstStorageReport)}
  'large-files' {$result=@(Get-WstLargeFile -Path $Path -MinimumSize $MinimumSize -Top $Top)}
  'cleanup-preview' {$result=@(Get-WstCleanupCandidate -OlderThanDays $OlderThanDays)}
  'export' {$file=Export-WstReport -Path $Path; Write-Host "Report written to $($file.FullName)"; exit 0}
 }
 if($Json){$result|ConvertTo-Json -Depth 6}else{$result|Format-Table -AutoSize}
} catch { Write-Error $_.Exception.Message; exit 2 }
