# Threat Model

| Threat | Mitigation | Residual risk |
|---|---|---|
| Untrusted API requests | Input validation, bounded request sizes, API tests | Must verify rate limiting |
| Compromised container | Non-root, dropped capabilities, read-only root FS | Image vulnerabilities remain |
| Unnecessary service access | Dedicated service accounts and NetworkPolicies | NetworkPolicy requires enforcing CNI |
| Model tampering | Record model digest and verify before release | Digest pinning must be configured |
| Secret leakage | Keep secrets out of Git; use Kubernetes Secrets | Secret encryption at rest depends on cluster |
| Supply-chain compromise | Trivy scan and SBOM artifacts | Scan results require review |
| Resource exhaustion | CPU/memory requests and limits | Load testing still required |
| Prompt manipulation | Bound instructions, validate tool/API inputs | Application-specific tests required |

## Trust boundaries
External client -> API Gateway -> Assistant -> Catalog and local LLM.
Treat user input, model output, retrieved catalog data and external images as
untrusted. Do not expose internal credentials to the model.
