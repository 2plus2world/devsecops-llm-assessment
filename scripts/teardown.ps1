param(
    [string]$Namespace = "devsecops-llm"
)

$ErrorActionPreference = "Stop"

Write-Host "This removes application resources in namespace: $Namespace"
Write-Host "Persistent data may be lost depending on storage configuration."
$confirmation = Read-Host "Type DELETE to continue"

if ($confirmation -cne "DELETE") {
    Write-Host "Teardown cancelled."
    exit 0
}

kubectl delete namespace $Namespace

if ($LASTEXITCODE -ne 0) {
    throw "Namespace deletion command failed."
}

Write-Host "Namespace deletion requested. Check cluster status before recreating."
