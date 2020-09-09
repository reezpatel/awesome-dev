module "metal-lb" {
  source = "./metal-lb"
}

module "local_storage" {
  source = "./local-storage"
}

module "metrics_server" {
  source = "./metrics-server"
}

module "nginx_ingress" {
  source = "./nginx-ingress"
}
