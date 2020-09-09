## Setup Kubernetes Cluster

This folder contains terraform files need to spin up a cluster with all services and applications installed.

Before starting, create a secret file at `terraform/services/metal-lb/secret.key` with a secret.
Secret can be generated using `openssl rand -base64 128`.

### Cluster Parts

- services

  - Metal LB = In cluster load balancer
  - Local Storage = Node local storage pvc provisioner
  - Metrics Server = Metrics collector
  - Nginx-Ingress = Ingress for cluster

- Databases
