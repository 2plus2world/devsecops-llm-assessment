$ErrorActionPreference = "Stop"

$reportDir = Join-Path $PSScriptRoot "..\reports"
New-Item -ItemType Directory -Force -Path $reportDir | Out-Null

$images = @(
    "ollama/ollama:latest"
)

foreach ($image in $images) {
    $safeName = $image -replace '[^a-zA-Z0-9._-]', '_'
    $sbomPath = Join-Path $reportDir "$safeName-sbom.json"
    $scanPath = Join-Path $reportDir "$safeName-trivy.json"

    Write-Host "Processing image: $image"

    if (-not (Get-Command trivy -ErrorAction SilentlyContinue)) {
        throw "Trivy is not installed. Install it before generating security reports."
    }

    trivy image --format cyclonedx --output $sbomPath $image
    if ($LASTEXITCODE -ne 0) { throw "SBOM generation failed for $image" }

    trivy image --format json --output $scanPath $image
    if ($LASTEXITCODE -ne 0) { throw "Image scan failed for $image" }

    Write-Host "Reports created for $image"
}

Write-Host "SBOM and scan report generation completed."
