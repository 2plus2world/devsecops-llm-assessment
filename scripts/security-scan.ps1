$ErrorActionPreference = "Continue"
New-Item -ItemType Directory -Force -Path reports | Out-Null

if (Get-Command trivy -ErrorAction SilentlyContinue) {
  trivy fs --scanners vuln,misconfig,secret --format json `
    --output reports\trivy-fs.json .
} else {
  Write-Warning "Trivy is not installed; filesystem scan was not run."
}

if (Get-Command syft -ErrorAction SilentlyContinue) {
  syft dir:. -o cyclonedx-json=reports\sbom.cdx.json
} else {
  Write-Warning "Syft is not installed; SBOM was not generated."
}

Write-Host "Review reports before release. Missing tools mean checks were skipped."
