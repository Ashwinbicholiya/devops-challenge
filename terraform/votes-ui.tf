# terraform/votes-ui.tf
resource "kubernetes_deployment" "votes_ui" {
  metadata {
    name      = "votes-ui"
    namespace = kubernetes_namespace.voting_app.metadata[0].name
    labels = { app = "votes-ui" }
  }

  spec {
    replicas = 1

    selector {
      match_labels = { app = "votes-ui" }
    }

    template {
      metadata {
        labels = { app = "votes-ui" }
      }

      spec {
        container {
          name              = "votes-ui"
          image             = "votes-ui:latest"
          image_pull_policy = "Never"

          port {
            name           = "http"
            container_port = 4000
          }

          env {
            name  = "PORT"
            value = "4000"
          }

          env {
            name  = "VOTES_API_HOST"
            value = "votes-api" 
          }

          env {
            name  = "VOTES_API_PORT"
            value = "80"
          }

          resources {
            requests = {
              cpu    = "50m"
              memory = "64Mi"
            }
            limits = {
              cpu    = "250m"
              memory = "256Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "votes_ui" {
  metadata {
    name      = "votes-ui"
    namespace = kubernetes_namespace.voting_app.metadata[0].name
    labels = { app = "votes-ui" }
  }

  spec {
    selector = { app = "votes-ui" }

    port {
      name        = "http"
      port        = 4000
      target_port = 4000
    }

    type = "ClusterIP"
  }
}
