# Monitoring

## Logs
Use kubectl logs to inspect application output:
kubectl logs deployment/api-gateway -n devsecops-llm
kubectl logs deployment/assistant -n devsecops-llm
kubectl logs deployment/catalog -n devsecops-llm
kubectl logs deployment/llm -n devsecops-llm

## Metrics and alerts
prometheus-alert-rules.yaml contains example Prometheus alert rules.
They require Prometheus plus kube-state-metrics and are not active merely
because this file exists.

## Alert delivery
Configure an Alertmanager receiver (email, Slack or another approved channel)
and test delivery before claiming alerts are operational.

## Structured logging
Applications should emit one JSON object per log event with timestamp,
service, severity, request_id and message. Avoid logging secrets, tokens,
personal data or full prompts containing sensitive information.
