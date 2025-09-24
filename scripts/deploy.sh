#!/bin/bash
set -e

# Minimal deploy: destroy + apply, build images and expose via port-forward
minikube status || minikube start
eval "$(minikube docker-env)"

# Tear down previous infra (ignore errors), then build images and apply terraform
(cd terraform && terraform destroy -auto-approve || true)
(cd votes-api && docker build -t votes-api:latest .)
(cd votes-ui && docker build -t votes-ui:latest .)
(cd terraform && terraform init -input=false && terraform apply -auto-approve)

# Start simple port-forwards and wait (keep script running)
kubectl port-forward -n voting-app svc/votes-api 5001:80 >/dev/null 2>&1 & API_PID=$!
kubectl port-forward -n voting-app svc/votes-ui 8081:4000 >/dev/null 2>&1 & UI_PID=$!
trap 'kill $API_PID $UI_PID 2>/dev/null' EXIT

echo "API: http://127.0.0.1:5001"
echo "UI:  http://127.0.0.1:8081"

wait $API_PID $UI_PID
