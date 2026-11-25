# Build APK release lalu publikasikan ke GitHub Releases.
# Device lain akan mendapat update lewat menu "Cek Update" di aplikasi.
#
# Sebelum menjalankan:
#   1. Naikkan versi di pubspec.yaml, mis. 1.0.0+1 -> 1.0.1+2
#      (angka setelah '+' WAJIB naik setiap rilis).
#   2. Isi kUpdateRepoOwner / kUpdateRepoName di lib/config/update_config.dart.
#   3. Login GitHub CLI sekali: gh auth login
#
# Pakai:  powershell -File tool\release.ps1 -Notes "Tambah menu rekap"

param(
    [string]$Notes = ""
)

$ErrorActionPreference = "Stop"
Set-Location (Join-Path $PSScriptRoot "..")

$versionLine = Select-String -Path pubspec.yaml -Pattern '^version:\s*(\S+)' | Select-Object -First 1
if (-not $versionLine) { throw "Baris 'version:' tidak ditemukan di pubspec.yaml" }
$version = $versionLine.Matches[0].Groups[1].Value
$tag = "v$version"

Write-Host "Build APK release $version ..."
flutter build apk --release
if ($LASTEXITCODE -ne 0) { throw "Build gagal" }

$apk = "build\app\outputs\flutter-apk\app-release.apk"
$asset = "build\app\outputs\flutter-apk\expense_tracker-$version.apk"
Copy-Item $apk $asset -Force

if (-not $Notes) { $Notes = "Rilis $version" }
Write-Host "Publikasi $tag ke GitHub Releases ..."
gh release create $tag $asset --title "Versi $version" --notes $Notes
if ($LASTEXITCODE -ne 0) { throw "gh release create gagal" }

Write-Host "Selesai. Device lain: buka menu > Cek Update."
