param(
  [string]$Root = "D:\Japan2026_Vlog"
)

$ErrorActionPreference = "Stop"

$days = @(
  "D01_0707_SZ-Tokyo",
  "D02_0708_Tokyo-teamLab-Ginza",
  "D03_0709_Asakusa-Shibuya",
  "D04_0710_Tokyo-Osaka-Shinkansen",
  "D05_0711_USJ",
  "D06_0712_Namba-Shinsaibashi-Dotonbori",
  "D07_0713_Osaka-HK-Shenzhen"
)

$deviceDirs = @(
  "A_CAM_A7M4",
  "B_CAM_ACTION5",
  "C_PHONE_IPHONE15PM",
  "D_PHONE_VIVO",
  "AUDIO_NOTES",
  "SELECTS",
  "_COPY_LOG"
)

$topDirs = @(
  "00_ADMIN",
  "01_FOOTAGE",
  "02_PHOTOS",
  "03_AUDIO",
  "04_PROJECT",
  "05_EXPORTS\LONG",
  "05_EXPORTS\SHORTS",
  "05_EXPORTS\THUMBNAILS",
  "06_CHECKSUMS"
)

foreach ($dir in $topDirs) {
  New-Item -ItemType Directory -Force -Path (Join-Path $Root $dir) | Out-Null
}

foreach ($day in $days) {
  foreach ($device in $deviceDirs) {
    New-Item -ItemType Directory -Force -Path (Join-Path $Root "01_FOOTAGE\$day\$device") | Out-Null
  }
  New-Item -ItemType Directory -Force -Path (Join-Path $Root "02_PHOTOS\$day") | Out-Null
}

$shootLog = Join-Path $Root "00_ADMIN\shoot_log.csv"
if (-not (Test-Path $shootLog)) {
  "date,day,city,devices_copied,backup_done,checksum_done,best_shot,notes" | Set-Content -Path $shootLog -Encoding UTF8
}

$readme = Join-Path $Root "00_ADMIN\README_STORAGE.md"
@"
# Japan 2026 Vlog Storage

Daily rule:
1. Copy each device into today's folder.
2. Generate SHA256 checksums.
3. Pick 20 clips into SELECTS.
4. Back up before formatting cards.

Device folders:
- A_CAM_A7M4
- B_CAM_ACTION5
- C_PHONE_IPHONE15PM
- D_PHONE_VIVO
- AUDIO_NOTES
- SELECTS
- _COPY_LOG
"@ | Set-Content -Path $readme -Encoding UTF8

Write-Host "Created vlog folder template at: $Root"
Write-Host "Next: copy today's footage into 01_FOOTAGE\Dxx...\device folders."
