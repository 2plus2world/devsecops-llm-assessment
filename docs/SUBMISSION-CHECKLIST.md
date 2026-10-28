# Assessment Submission Checklist

## Implemented/configured (runtime verification pending)
- [x] API Gateway, Assistant, Catalog and local LLM Kubernetes manifests exist
- [x] Dedicated ServiceAccounts configured
- [x] Container security contexts and resource requests/limits configured
- [x] NetworkPolicy YAML drafted and server-side dry-run passed
- [x] Runbook, threat model, offline guide and AI usage disclosure created
- [x] CI workflow and security scan/SBOM scripts created
- [x] Prometheus example alert rules and monitoring notes created
- [x] File-based SHA-256 integrity verification script created

## Must verify before submission
- [ ] End-to-end request works through API Gateway
- [ ] Ollama model is present and CPU-only inference succeeds
- [ ] Model and prompt checks use trusted expected hashes
- [ ] NetworkPolicy is enforced by the installed CNI
- [ ] CI workflow succeeds
- [ ] Trivy scan and SBOM are generated and reviewed
- [ ] Offline bundle includes every required image and model artifact
- [ ] Metrics and alert delivery are operational
- [ ] Rollback and teardown behavior is understood

## Evidence to capture
- [ ] Kubernetes pods and deployments ready
- [ ] Successful API request and response
- [ ] Resource limits and security contexts
- [ ] Successful CI run
- [ ] Scan and SBOM reports
- [ ] Model integrity verification result
- [ ] Network isolation evidence
- [ ] Offline deployment evidence

Do not mark a runtime item complete until it has been tested and evidence saved.
