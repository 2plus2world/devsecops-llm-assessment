# Model and prompt integrity verification
# Set the expected SHA-256 values from a trusted release manifest.
# Do not calculate the expected hash from the same untrusted file being checked.

param(
    [Parameter(Mandatory=$true)][string]$ModelArtifact,
    [Parameter(Mandatory=$true)][string]$ExpectedModelSha256,
    [Parameter(Mandatory=$true)][string]$PromptFile,
    [Parameter(Mandatory=$true)][string]$ExpectedPromptSha256
)

$ErrorActionPreference = "Stop"

$modelHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $ModelArtifact).Hash.ToLower()
$promptHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $PromptFile).Hash.ToLower()

if ($modelHash -ne $ExpectedModelSha256.ToLower()) {
    throw "MODEL CHECKSUM MISMATCH"
}

if ($promptHash -ne $ExpectedPromptSha256.ToLower()) {
    throw "PROMPT CHECKSUM MISMATCH"
}

Write-Host "Model and prompt SHA-256 checks passed."
