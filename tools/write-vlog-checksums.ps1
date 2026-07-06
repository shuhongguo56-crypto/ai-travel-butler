param(
  [string]$Root = "D:\Japan2026_Vlog",
  [string]$Day = ""
)

$ErrorActionPreference = "Stop"

$source = Join-Path $Root "01_FOOTAGE"
if ($Day.Trim().Length -gt 0) {
  $source = Join-Path $source $Day
}

if (-not (Test-Path $source)) {
  throw "Source folder not found: $source"
}

$checksumDir = Join-Path $Root "06_CHECKSUMS"
New-Item -ItemType Directory -Force -Path $checksumDir | Out-Null

$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$name = if ($Day.Trim().Length -gt 0) { "checksums_${Day}_${stamp}.csv" } else { "checksums_all_${stamp}.csv" }
$output = Join-Path $checksumDir $name

Get-ChildItem $source -Recurse -File |
  Get-FileHash -Algorithm SHA256 |
  Select-Object Algorithm, Hash, Path |
  Export-Csv $output -NoTypeInformation -Encoding UTF8

Write-Host "Checksum file written: $output"
