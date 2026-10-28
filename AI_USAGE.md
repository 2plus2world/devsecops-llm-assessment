# AI Usage Disclosure

## AI-assisted development
AI tools were used to assist with planning, drafting documentation,
generating starter scripts, and reviewing Kubernetes security concepts.

## Human review
Generated code and configuration must be reviewed before production use.
Runtime behavior and security claims must be supported by test evidence.

## Model
The deployment is designed to use a local CPU-only Ollama model.
The selected model and exact artifact digest must be recorded for release.

## Limitations
- No claim of complete offline readiness until tested without internet.
- NetworkPolicy enforcement depends on the cluster CNI.
- Model and prompt integrity checks require trusted expected SHA-256 values.
- Vulnerability scan, SBOM, monitoring and CI results must be retained as evidence.
- AI-generated content may contain errors and requires verification.

## Representative Prompts and Human Changes

AI assistance was used for architecture planning, documentation,
Kubernetes security review, and starter scripts.

Representative prompt categories:
- Review Kubernetes manifests for least privilege and resource limits.
- Draft an offline deployment and recovery runbook.
- Help structure SBOM generation and container vulnerability scanning.

Human review and changes:
- Reviewed generated manifests and scripts before execution.
- Validated Kubernetes manifests using kubectl dry-run.
- Tested local LLM inference and the API request.
- Recorded scan findings and documented unverified capabilities
  as limitations rather than claiming they passed.

## Validation Boundaries

Only report checks supported by retained evidence.
The Ollama image scan does not establish that every application
image has been scanned. Offline readiness and NetworkPolicy
enforcement must be reported only after their respective tests.
