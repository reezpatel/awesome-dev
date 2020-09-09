variable "mysql_root_password" {
  type        = string
  description = "MYSQL Root Password"
}

variable "mongodb_root_password" {
  type        = string
  description = "Mogodb Root Password"
}

variable "drone_rpc_secret" {
  type        = string
  description = "Drone CI RPC Secret"
}

variable "drone_github_client_id" {
  type        = string
  description = "Drone Github Client ID"
}

variable "drone_github_client_secret" {
  type        = string
  description = "Drone Github Client Secret"
}
