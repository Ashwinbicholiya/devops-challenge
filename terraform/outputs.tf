# terraform/outputs.tf

output "namespace" {
  description = "Kubernetes namespace used for the voting app"
  value       = kubernetes_namespace.voting_app.metadata[0].name
}

output "votes_api_cluster_ip" {
  description = "ClusterIP of the votes-api service"
  value       = kubernetes_service.votes_api.spec[0].cluster_ip
}

output "votes_api_port" {
  description = "Port for the votes-api service inside the cluster"
  value       = kubernetes_service.votes_api.spec[0].port[0].port
}

output "votes_ui_cluster_ip" {
  description = "ClusterIP of the votes-ui service"
  value       = kubernetes_service.votes_ui.spec[0].cluster_ip
}

output "votes_ui_port" {
  description = "Port for the votes-ui service inside the cluster"
  value       = kubernetes_service.votes_ui.spec[0].port[0].port
}

output "votes_api_image" {
  description = "Image used by votes-api deployment (tag)"
  value       = "votes-api:latest"
}

output "votes_ui_image" {
  description = "Image used by votes-ui deployment (tag)"
  value       = "votes-ui:latest"
}
