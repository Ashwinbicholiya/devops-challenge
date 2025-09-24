# terraform/variables.tf
variable "namespace" {
  description = "Kubernetes namespace for the voting application"
  type        = string
  default     = "voting-app"
}

variable "db_password" {
  description = "PostgreSQL database password"
  type        = string
  default     = "postgres"
  sensitive   = true
}

variable "db_user" {
  description = "PostgreSQL database user"
  type        = string
  default     = "postgres"
}

variable "db_name" {
  description = "PostgreSQL database name"
  type        = string
  default     = "postgres"
}
