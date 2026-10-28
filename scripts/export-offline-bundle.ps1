
param(
    [string]$Model = "qwen2.5:0.5b",
    [string]$OutputDir = ".\offline-bundle"
)

$ErrorActionPreference = "Stop"

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    throw "Docker CLI not found."
}

if (-not (Get-Command kubectl -ErrorAction SilentlyContinue)) {
    throw "kubectl not found."
}

New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null
New-Item -ItemType Directory -Force -Path ".\reports" | Out-Null

# Export the Ollama model from the running Kubernetes pod.
$pod = kubectl get pods -n devsecops-llm -l app=llm `
    -o jsonpath='{.items[0].metadata.name}'

if (-not $pod) {
    throw "LLM pod not found in namespace devsecops-llm."
}

$modelList = kubectl exec -n devsecops-llm $pod -- ollama list
if ($LASTEXITCODE -ne 0 -or ($modelList -join "`n") -notmatch [regex]::Escape($Model)) {
    throw "Model '$Model' is not present in the LLM pod."
}

$modelfile = "FROM $Model"
$modelfilePath = Join-Path $OutputDir "Modelfile"
$modelfile | Set-Content -Encoding ascii $modelfilePath

# Export model as an Ollama-compatible archive.
$archiveName = "qwen-model.tar"
$archivePath = Join-Path $OutputDir $archiveName

kubectl exec -i -n devsecops-llm $pod -- ollama show $Model | Out-Null
if ($LASTEXITCODE -ne 0) {
    throw "Could not inspect model '$Model'."
}

# Save the model through the Ollama API using a temporary helper container
# is not portable across all clusters. Use ollama create only after transferring
# model blobs through a supported registry or storage mechanism.
Write-Warning "Model image export needs a supported transfer method; this script does not claim to export model blobs."
Write-Warning "Use 'ollama save' only if your installed Ollama CLI supports it; standard Ollama CLI generally uses 'ollama pull' and 'ollama push'."

# Export the Ollama container image.
$image = "ollama/ollama:latest"
docker image inspect $image *> $null
if ($LASTEXITCODE -eq 0) {
    docker save -o (Join-Path $OutputDir "ollama-image.tar") $image
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to export Ollama image."
    }
} else {
    Write-Warning "Image '$image' is not available in local Docker; skipping."
}

Get-ChildItem $OutputDir -File |
    Get-FileHash -Algorithm SHA256 |
    ForEach-Object {
        "$($_.Hash)  $($_.Path | Split-Path -Leaf)"
    } |
    Set-Content -Encoding ascii (Join-Path $OutputDir "SHA256SUMS.txt")

Write-Host "Export step finished. IMPORTANT: model archive is not included until a supported model transfer method is configured."
