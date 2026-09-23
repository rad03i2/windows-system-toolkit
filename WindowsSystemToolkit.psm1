Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function ConvertTo-WstBytes {
    [CmdletBinding()]
    param([Parameter(Mandatory)][string]$Value)
    if ($Value -notmatch '^\s*(\d+(?:\.\d+)?)\s*(B|KB|MB|GB|TB)?\s*$') { throw "Invalid size: $Value" }
    $n = [double]$Matches[1]; $u = if ($Matches[2]) { $Matches[2].ToUpperInvariant() } else { 'B' }
    $power = @{B=0;KB=1;MB=2;GB=3;TB=4}[$u]
    return [int64]($n * [math]::Pow(1024,$power))
}

function Format-WstBytes {
    [CmdletBinding()]
    param([Parameter(Mandatory)][long]$Bytes)
    foreach ($u in @('TB','GB','MB','KB')) {
        $p = @{KB=1;MB=2;GB=3;TB=4}[$u]; $d=[math]::Pow(1024,$p)
        if ([math]::Abs($Bytes) -ge $d) { return ('{0:N2} {1}' -f ($Bytes/$d),$u) }
    }
    return "$Bytes B"
}

function Get-WstSystemReport {
    [CmdletBinding()]
    param()
    $os = Get-CimInstance Win32_OperatingSystem
    $cs = Get-CimInstance Win32_ComputerSystem
    $cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
    [pscustomobject]@{
        ComputerName=$env:COMPUTERNAME; UserName=$env:USERNAME; Windows=$os.Caption; Version=$os.Version
        Architecture=$os.OSArchitecture; Manufacturer=$cs.Manufacturer; Model=$cs.Model
        Processor=$cpu.Name; LogicalProcessors=$cs.NumberOfLogicalProcessors
        MemoryBytes=[int64]$cs.TotalPhysicalMemory; Memory=(Format-WstBytes $cs.TotalPhysicalMemory)
        LastBootTime=$os.LastBootUpTime; CollectedAt=(Get-Date).ToUniversalTime().ToString('o')
    }
}

function Get-WstStorageReport {
    [CmdletBinding()]
    param()
    Get-CimInstance Win32_LogicalDisk -Filter 'DriveType=3' | ForEach-Object {
        $used=[int64]$_.Size-[int64]$_.FreeSpace
        [pscustomobject]@{Drive=$_.DeviceID; FileSystem=$_.FileSystem; SizeBytes=[int64]$_.Size; FreeBytes=[int64]$_.FreeSpace; UsedBytes=$used; FreePercent=if($_.Size){[math]::Round(100*$_.FreeSpace/$_.Size,1)}else{0}}
    }
}

function Get-WstLargeFile {
    [CmdletBinding()]
    param([Parameter(Mandatory)][string]$Path,[string]$MinimumSize='500MB',[int]$Top=25)
    if (!(Test-Path -LiteralPath $Path -PathType Container)) { throw "Directory not found: $Path" }
    $min=ConvertTo-WstBytes $MinimumSize
    Get-ChildItem -LiteralPath $Path -File -Recurse -Force -ErrorAction SilentlyContinue |
        Where-Object Length -ge $min | Sort-Object Length -Descending | Select-Object -First $Top FullName,Length,LastWriteTime,@{N='Size';E={Format-WstBytes $_.Length}}
}

function Get-WstCleanupCandidate {
    [CmdletBinding()]
    param([int]$OlderThanDays=7)
    if($OlderThanDays -lt 0){throw 'OlderThanDays must be zero or greater.'}
    $cutoff=(Get-Date).AddDays(-$OlderThanDays)
    $roots=@($env:TEMP, "$env:LOCALAPPDATA\Temp") | Where-Object { $_ -and (Test-Path -LiteralPath $_) } | Select-Object -Unique
    foreach($root in $roots){
        Get-ChildItem -LiteralPath $root -File -Recurse -Force -ErrorAction SilentlyContinue |
          Where-Object LastWriteTime -lt $cutoff | ForEach-Object {[pscustomobject]@{Path=$_.FullName;Length=$_.Length;Size=(Format-WstBytes $_.Length);LastWriteTime=$_.LastWriteTime}}
    }
}

function Export-WstReport {
    [CmdletBinding()]
    param([Parameter(Mandatory)][string]$Path)
    $report=[ordered]@{system=Get-WstSystemReport;storage=@(Get-WstStorageReport);generatedAt=(Get-Date).ToUniversalTime().ToString('o')}
    $json=$report|ConvertTo-Json -Depth 6
    $parent=Split-Path -Parent $Path; if($parent -and !(Test-Path $parent)){New-Item -ItemType Directory -Path $parent -Force|Out-Null}
    [IO.File]::WriteAllText([IO.Path]::GetFullPath($Path),$json,[Text.UTF8Encoding]::new($false))
    Get-Item -LiteralPath $Path
}

Export-ModuleMember -Function ConvertTo-WstBytes,Format-WstBytes,Get-WstSystemReport,Get-WstStorageReport,Get-WstLargeFile,Get-WstCleanupCandidate,Export-WstReport
