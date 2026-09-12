param(
    [string]$Target = "$env:TEMP"
)

Write-Host "Cleanup preview for: $Target"
if (!(Test-Path $Target)) {
    Write-Error "Target path does not exist."
    exit 1
}

Get-ChildItem $Target -Recurse -ErrorAction SilentlyContinue |
    Where-Object { -not $_.PSIsContainer } |
    Sort-Object Length -Descending |
    Select-Object -First 20 FullName, Length, LastWriteTime |
    Format-Table -AutoSize

Write-Host "Preview only. No files were deleted."
