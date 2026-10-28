# Offline Deployment Preparation

This project is not offline-ready merely because it runs locally.

Before disconnecting from the internet:
1. Build all application images.
2. Pull the exact Ollama image and download the required model.
3. Record image tags/digests and the model digest.
4. Save container images as tar archives.
5. Copy the model storage or export it using a supported Ollama workflow.
6. Transfer the bundle securely and verify SHA256 checksums.
7. Load images into the target Docker/container runtime.
8. Confirm manifests do not require image pulls or runtime downloads.

Use scripts/export-offline-bundle.ps1 to export local Docker images.
Model export and import must be handled separately; this script does not claim
to export model data.
