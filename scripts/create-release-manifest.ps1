$ErrorActionPreference = "Stop"

$root = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$reportDir = Join-Path $root "reports"
$manifest = Join-Path $reportDir "release-sha256.txt"

New-Item -ItemType Directory -Force -Path $reportDir | Out-Null

$files = Get-ChildItem $root -Recurse -File |
    Where-Object {
        $_.FullName -notmatch '[\\/](\.git|reports)[\\/]' -and
        $_.Name -ne "release-sha256.txt"
    } |
    Sort-Object FullName

if (-not $files) {
    throw "No release files found."
}

$lines = foreach ($file in $files) {
    $hash = (Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256).Hash.ToLower()
    $relativePath = $file.FullName.Substring($root.Length).TrimStart('\','/')
    "$hash  $relativePath"
}

$lines | Set-Content -LiteralPath $manifest -Encoding utf8

Write-Host "Release checksum manifest created: reports\release-sha256.txt"
Write-Host "This records file hashes; it does not build or package container images."
