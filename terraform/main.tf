# variable "k_nodes" {
#   type = map
#   default = {
#     athena  = "vmi429275.contaboserver.net" # Master Node
#     hanzo   = "vmi429536.contaboserver.net" # Application Node
#     pharah  = "vmi429533.contaboserver.net" # Application Node
#     winston = "vmi429534.contaboserver.net" # MQ, DB Node
#     dva     = "vmi429535.contaboserver.net" # ELK and Monitoring
#   }
# }

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  debug = true
  kubernetes {
    config_path = "~/.kube/config"
  }
}

module "services" {
  source = "./services"
}

module "application" {
  source                     = "./applications"
  mysql_root_password        = var.mysql_root_password
  mongodb_root_password      = var.mongodb_root_password
  drone_rpc_secret           = var.drone_rpc_secret
  drone_github_client_id     = var.drone_github_client_id
  drone_github_client_secret = var.drone_github_client_secret
}


module "monitoring" {
  source = "./monitoring"
}
