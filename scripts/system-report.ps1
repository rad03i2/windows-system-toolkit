$computer = Get-ComputerInfo
$drives = Get-PSDrive -PSProvider FileSystem

Write-Host "Windows System Toolkit Report"
Write-Host "Generated: $(Get-Date)"
Write-Host "Computer: $($computer.CsName)"
Write-Host "OS: $($computer.WindowsProductName)"
Write-Host "Version: $($computer.WindowsVersion)"
Write-Host "`nDrives:"

foreach ($drive in $drives) {
    $used = $drive.Used / 1GB
    $free = $drive.Free / 1GB
    Write-Host ("{0}: Used {1:N2} GB | Free {2:N2} GB" -f $drive.Name, $used, $free)
}
