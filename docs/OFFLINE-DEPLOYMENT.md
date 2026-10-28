# Offline Deployment Guide

## Objective
Deploy the API Gateway, Assistant, Catalog and CPU-only Ollama LLM
in an environment without runtime internet access.

## Preparation on an internet-connected machine
1. Pin and record the approved container image versions.
2. Pull every required image and save it as an archive.
3. Download the approved Qwen2.5-0.5B model.
4. Record SHA-256 checksums from a trusted source.
5. Transfer image archives, model artifacts and manifests securely.

## Offline cluster preparation
1. Load image archives into the target container runtime.
2. Configure workloads to use the preloaded images.
3. Set imagePullPolicy to IfNotPresent or Never as appropriate.
4. Ensure model artifacts are available locally before starting Ollama.
5. Apply Kubernetes manifests and verify readiness.
6. Confirm runtime workloads do not require internet access.

## Important limitations to resolve
- The current llm.yaml uses ollama/ollama:latest; pin an approved version.
- The current model volume is emptyDir and does not persist across pod replacement.
- The model must be preloaded or supplied from a verified local artifact.
- NetworkPolicy enforcement depends on a CNI that supports NetworkPolicy.
- Do not claim offline readiness until the deployment is tested without internet.

## Recovery
Keep the exact image archives, model artifacts, checksums and manifests
with the release so the environment can be recreated.
