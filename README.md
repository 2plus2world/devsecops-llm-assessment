# DevSecOps + MLOps CPU-only LLM

## Architecture
- API Gateway: external application entry point.
- Assistant: coordinates catalog retrieval and LLM inference.
- Catalog: product/catalog API.
- Ollama: local CPU-only inference using qwen2.5:0.5b.

## Security
- Dedicated Kubernetes ServiceAccounts.
- Restricted Pod Security namespace.
- Non-root execution where supported, read-only root filesystems,
  dropped Linux capabilities and resource requests/limits.
- NetworkPolicy manifests are provided; enforcement depends on the CNI.
- Do not store credentials in source control.

## Operations
See docs/RUNBOOK.md for deploy, rollback and teardown.
See docs/THREAT_MODEL.md for key risks.
See docs/OFFLINE.md for offline deployment preparation.

## CI
GitHub Actions workflow performs source checks. Run scripts/security-scan.ps1
to build an SBOM and run Trivy when the tools and images are available.

## Limitations
Do not claim network isolation, offline operation, alert delivery or model
integrity verification until the corresponding runtime checks have passed.

## Container Image Security Scan

- Image scanned: ollama/ollama:latest
- Scanner: Trivy 0.76.1
- SBOM format: CycloneDX
- OS package findings: 30 (7 Low, 23 Medium)
- Ollama binary findings: 1 (UNKNOWN severity)
- High/Critical findings reported: 0
- Reports:
  - reports/ollama-trivy-report.json
  - reports/ollama_ollama_latest-sbom.json

Note: Findings must be reviewed against fixed versions and exploitability.
The image is not declared vulnerability-free. Re-scan after remediation.

