# Runbook

## Deploy
1. Confirm Docker Desktop and the intended Kubernetes context are available.
2. Build/load application images as required by the manifests.
3. Ensure the Ollama model qwen2.5:0.5b is available to the LLM service.
4. Apply namespace/security/application manifests.
5. Confirm deployments and service endpoints are ready.
6. Run the project's API smoke tests.

## Troubleshooting
- ImagePullBackOff: check image name, tag and kind image loading.
- CrashLoopBackOff: inspect the failing container logs and previous logs.
- LLM unavailable: confirm Ollama is ready and the configured model exists.
- Assistant unavailable: check service DNS, ports and application logs.
- NetworkPolicy: verify the CNI actually enforces policies before relying on them.

## Rollback
Use the last known-good image tag, then:
kubectl rollout undo deployment/api-gateway -n devsecops-llm
kubectl rollout undo deployment/assistant -n devsecops-llm
kubectl rollout undo deployment/catalog -n devsecops-llm
kubectl rollout undo deployment/llm -n devsecops-llm

## Teardown
kubectl delete namespace devsecops-llm
Warning: namespace deletion removes application resources and persistent claims
in that namespace. Back up any model/data you need before teardown.
