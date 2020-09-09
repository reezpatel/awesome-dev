resource "kubernetes_namespace" "database_namespace" {
  metadata {
    annotations = {
      name = "database"
    }

    name = "database"
  }
}

resource "kubernetes_namespace" "automation_namespace" {
  metadata {
    annotations = {
      name = "automation"
    }

    name = "automation"
  }
}

resource "kubernetes_namespace" "gitpod_namespace" {
  metadata {
    annotations = {
      name = "gitpod"
    }

    name = "gitpod"
  }
}

module "mongodb" {
  source                = "./mongodb"
  mongodb_root_password = var.mongodb_root_password
}

module "mysql" {
  source              = "./mysql"
  mysql_root_password = var.mysql_root_password
}

module "redis" {
  source = "./redis"
}

module "drone_ci" {
  source                     = "./drone-ci"
  drone_rpc_secret           = var.drone_rpc_secret
  drone_github_client_id     = var.drone_github_client_id
  drone_github_client_secret = var.drone_github_client_secret
}

module "drone_runner" {
  source           = "./drone_runner"
  drone_rpc_secret = var.drone_rpc_secret
}
