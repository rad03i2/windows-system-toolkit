$ErrorActionPreference='Stop'
Import-Module (Join-Path $PSScriptRoot '..\WindowsSystemToolkit.psm1') -Force
$failed=0
function Assert-Equal($Expected,$Actual,$Name){if($Expected -ne $Actual){Write-Error "$Name expected '$Expected', got '$Actual'";$script:failed++}else{Write-Host "PASS $Name"}}
function Assert-True($Value,$Name){if(!$Value){Write-Error "$Name failed";$script:failed++}else{Write-Host "PASS $Name"}}
Assert-Equal 1024 (ConvertTo-WstBytes '1KB') 'parse KB'
Assert-Equal 1572864 (ConvertTo-WstBytes '1.5 MB') 'parse decimal MB'
Assert-Equal '1.00 KB' (Format-WstBytes 1024) 'format KB'
$threw=$false;try{ConvertTo-WstBytes 'abc'|Out-Null}catch{$threw=$true};Assert-True $threw 'reject invalid size'
$temp=Join-Path ([IO.Path]::GetTempPath()) ('wst-test-'+[guid]::NewGuid());New-Item -ItemType Directory $temp|Out-Null
try{
 [IO.File]::WriteAllBytes((Join-Path $temp 'large.bin'),[byte[]]::new(2048));[IO.File]::WriteAllBytes((Join-Path $temp 'small.bin'),[byte[]]::new(10))
 $files=@(Get-WstLargeFile -Path $temp -MinimumSize '1KB');Assert-Equal 1 $files.Count 'large file filter';Assert-True ($files[0].FullName -like '*large.bin') 'large file result'
}finally{Remove-Item $temp -Recurse -Force -ErrorAction SilentlyContinue}
if($failed){Write-Error "$failed test(s) failed";exit 1};Write-Host 'All tests passed.'
