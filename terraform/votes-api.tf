# terraform/votes-api.tf
resource "kubernetes_deployment" "votes_api" {
  metadata {
    name      = "votes-api"
    namespace = kubernetes_namespace.voting_app.metadata[0].name
    labels = {
      app = "votes-api"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "votes-api"
      }
    }

    template {
      metadata {
        labels = {
          app = "votes-api"
        }
      }

      spec {
        container {
          name              = "votes-api"
          image             = "votes-api:latest"
          image_pull_policy = "Never"

          port {
            name           = "http"
            container_port = 80
          }

          env {
            name  = "POSTGRES_HOST"
            value = "postgres"
          }
          env {
            name  = "POSTGRES_USER"
            value = var.db_user
          }
          env {
            name  = "POSTGRES_PASSWORD"
            value = var.db_password
          }
          env {
            name  = "POSTGRES_DB"
            value = var.db_name
          }
          env {
            name  = "OPTION_A"
            value = "Cats"
          }
          env {
            name  = "OPTION_B"
            value = "Dogs"
          }
          env {
            name  = "PORT"
            value = "80"
          }

          readiness_probe {
            http_get {
              path = "/"
              port = "http"
            }
            initial_delay_seconds = 3
            period_seconds        = 10
          }

          liveness_probe {
            http_get {
              path = "/"
              port = "http"
            }
            initial_delay_seconds = 10
            period_seconds        = 20
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

resource "kubernetes_service" "votes_api" {
  metadata {
    name      = "votes-api"
    namespace = kubernetes_namespace.voting_app.metadata[0].name
    labels = {
      app = "votes-api"
    }
  }

  spec {
    selector = {
      app = "votes-api"
    }

    port {
      name        = "http"
      port        = 80
      target_port = 80
    }

    type = "ClusterIP"
  }
}
