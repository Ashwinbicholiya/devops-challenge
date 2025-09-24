# Quick deploy
Keep the terminal running while the helper starts port-forwards.

Prereqs: Docker (or Rancher Desktop), Minikube, kubectl, Terraform.

Install:
- Minikube: https://minikube.sigs.k8s.io/docs/start/  ` (brew install minikube)`
- kubectl: https://kubernetes.io/docs/tasks/tools/     `(brew install kubectl)`
- Terraform: https://developer.hashicorp.com/terraform/downloads   `(brew install terraform)`
- Docker Desktop: https://docs.docker.com/get-docker/
- Rancher Desktop: https://rancherdesktop.io/

Steps:
1. Start Minikube (if not running):
   `minikube start`
2. Run the helper from repo root:
   `bash scripts/deploy.sh`

Open:
- UI:  `http://127.0.0.1:8081`
- API: `http://127.0.0.1:5001`

Common endpoints:
- GET /healthz  `http://127.0.0.1:5001/healthz`
- POST /vote    `http://127.0.0.1:5001/vote`  (JSON {"vote":"a"} / {"vote":"b"})
- GET /results  [http://127.0.0.1:5001/results]()

Quick checks:
- `kubectl get pods,svc -n voting-app`
- `curl http://127.0.0.1:5001/healthz`
- `kubectl logs -n voting-app -l app=votes-api --tail=100`

Stop & cleanup:
- Ctrl+C to stop helper (port-forwards)
- `cd terraform && terraform destroy -auto-approve`

Prod checklist (short):
- Secrets: use Google Secret Manager (no .env in repo).
- CI: GitHub Actions – build, test, scan images, push images tags to registry.
- CD: Spinnaker for safe Kubernetes rollouts.
- Terraform: dedicated repo, remote state (GCS) + locking and use Atlantis for PR-based runs.
- Observability: Prometheus + Grafana, central logs, tracing.
