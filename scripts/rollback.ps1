param(
    [string]$Namespace = "devsecops-llm",
    [string]$Deployment = "assistant",
    [int]$Revision = 0
)

$ErrorActionPreference = "Stop"

if ($Revision -gt 0) {
    kubectl rollout undo "deployment/$Deployment" -n $Namespace --to-revision=$Revision
} else {
    kubectl rollout undo "deployment/$Deployment" -n $Namespace
}

if ($LASTEXITCODE -ne 0) {
    throw "Rollback command failed."
}

kubectl rollout status "deployment/$Deployment" -n $Namespace --timeout=120s

if ($LASTEXITCODE -ne 0) {
    throw "Rollback was requested, but rollout did not complete successfully."
}

Write-Host "Rollback completed for $Deployment."
