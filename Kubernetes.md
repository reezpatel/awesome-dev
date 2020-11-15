## Create a Self Hosted Kubernetes Cluster

This readme will guide you to create a self managed Kubernetes cluster. This guide covers creating a cluster with 5 nodes (1 master + 4 worker), Setup CNI, Kubernetes Dashboard, Kubernetes native storage, Monitoring, Logging, Database and some other applications.

### Requirements

1. Min X3 - VMs with CentOS (Tested on Cent OS 8) - Min. 2 vCPU and 4 GB RAM
2. Unformatted Partitions in VMs for storage
3. Root SSH Access to all VMs
4. Ansible Installed on local machine
5. Helm Installed locally
6. Kubectl Installed locally

### Content

1. Setup VM
2. Install Docker & Kubeadm
3. Setup Firewall
4. Create Kubeadm cluster
5. Install basic applications
6. Setup Storage Solution
7. Install Monitoring Stack
8. Install Database & Other Services
9. Installing ELK Stack
10. Install other Applications

---

#### Configure Ansible

Create `vars.yml` and `hosts` file inside `ansible` folder.

###### hosts

```
s0.example.com
s1.example.com
s2.example.com
s3.example.com
s4.example.com
s5.example.com

[main]
s0.example.com

[subordinate]
s1.example.com
s2.example.com
s3.example.com
s4.example.com
s5.example.com
```

###### vars.yml

```
SUDO_USER: <non-root-sudo-username>
SUDO_USER_PASSWORD: <non-root-sudo-password>
MASTER_NODE_HOST: <master-node-host-or-ip>
ansible_sudo_pass: <non-root-sudo-password>
ansible_password: <root-password>
token: <kubernetes-join-token>
```

#### Setup VM

Depending to the need there are three playbook to help you get started.

```bash
# Setup hostname
ansible-playbook -i hosts -e @./vars.yml playbooks/hostname.yaml

# Add non-root sudo user
ansible-playbook -i hosts -e @./vars.yml playbooks/add-user.yaml

# Install prerequisite for kubeadm and docker
ansible-playbook -i hosts -e @./vars.yml playbooks/prerequisite.yaml
```

#### Install Docker & Kubeadm

Use `docker.yaml` ansible playbook to setup docker on CentOS and `kubeadm-install.yaml` to install kubeadm

```bash
# Install docker
ansible-playbook -i hosts -e @./vars.yml playbooks/docker.yaml

# Install kubeadm
ansible-playbook -i hosts -e @./vars.yml playbooks/kubeadm-install.yaml
```

### Setup Firewall

Run this command to install firewalld and open ports for kube-cluster to communicate.

```bash
ansible-playbook -i hosts -e @./vars.yml playbooks/Firewall.yaml
```

### Create Kubeadm cluster

Use `kubeadm-init.yaml` to create your cluster with one master node.

```bash
ansible-playbook -i hosts -e @./vars.yml playbooks/kubeadm-init.yml
```

Use `scp <username>@<master-host-or-ip>:~/.kube/config ~/.kube/config` to get the kubeconfig

### Install basic applications

> Note: From this point this guide assumes that kubectl is installed in your local system, and `kubeconfig` is copied in your local machine.

##### Install CNI - Calico

There are many CNI available for kubernetes, calico is one of popular one with a great community support.
To install calico run following command

```bash
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
```

This will take some time, use the command `kubectl get pods --all-namespaces` and `kubectl get nodes` to make sure all pods and node are up and running.

```
> kubectl get pods --all-namespaces
NAMESPACE     NAME                                      READY   STATUS    RESTARTS   AGE
kube-system   calico-kube-controllers-8f59968d4-5xj8b   1/1     Running   0          43s
kube-system   calico-node-49qw2                         1/1     Running   0          45s
kube-system   calico-node-4zknj                         1/1     Running   0          45s
kube-system   calico-node-7zdk6                         1/1     Running   0          45s
kube-system   calico-node-mt49k                         1/1     Running   0          45s
kube-system   calico-node-t9k5b                         1/1     Running   0          45s
kube-system   calico-node-zmfq5                         1/1     Running   0          45s
kube-system   coredns-f9fd979d6-gvt5m                   1/1     Running   0          3m22s
kube-system   coredns-f9fd979d6-zpzbs                   1/1     Running   0          3m22s
kube-system   etcd-s0.example.com                          1/1     Running   0          3m32s
kube-system   kube-apiserver-s0.example.com                1/1     Running   0          3m32s
kube-system   kube-controller-manager-s0.example.com       1/1     Running   0          3m32s
kube-system   kube-proxy-477km                          1/1     Running   0          2m53s
kube-system   kube-proxy-dk5ff                          1/1     Running   0          2m52s
kube-system   kube-proxy-gtm9x                          1/1     Running   0          3m22s
kube-system   kube-proxy-jtwgh                          1/1     Running   0          2m49s
kube-system   kube-proxy-pn9bc                          1/1     Running   0          2m52s
kube-system   kube-proxy-z8pww                          1/1     Running   0          2m52s
kube-system   kube-scheduler-s0.example.com                1/1     Running   0          3m32s

```

```
> kubect; get nodes
NAME          STATUS   ROLES    AGE     VERSION
s0.example.com   Ready    master   3m37s   v1.19.3
s1.example.com   Ready    <none>   2m45s   v1.19.3
s2.example.com   Ready    <none>   2m49s   v1.19.3
s3.example.com   Ready    <none>   2m48s   v1.19.3
s4.example.com   Ready    <none>   2m48s   v1.19.3
s5.example.com   Ready    <none>   2m48s   v1.19.3
```

##### Install Kubeapps

Use helm to install kubeapps

```bash
# Install Kubeapps - Wait to pods to start
helm repo add bitnami https://charts.bitnami.com/bitnami
kubectl create namespace kubeapps
helm install kubeapps --namespace kubeapps bitnami/kubeapps

# Create SA
kubectl create serviceaccount kubeapps-operator
kubectl create clusterrolebinding kubeapps-operator --clusterrole=cluster-admin --serviceaccount=default:kubeapps-operator

# Get access token
kubectl get secret $(kubectl get serviceaccount kubeapps-operator -o jsonpath='{range .secrets[*]}{.name}{"\n"}{end}' | grep kubeapps-operator-token) -o jsonpath='{.data.token}' -o go-template='{{.data.token | base64decode}}' && echo

# Access Kubeapps - Use token from previous step to login
kubectl port-forward -n kubeapps svc/kubeapps 8080:80
```

### Setup Storage Solution

For storage we will be installing Rook. This required and Unformatted drive or Partition. Make sure atleast of the worker node qualifies this need.

Use Kubeapps or kubectl & Helm to do the following

1. Create a namespace `rook-ceph`
2. Install Rook Operator using [helm chart](https://github.com/rook/rook/blob/master/Documentation/helm-operator.md)
3. Run `kubectl apply -f https://raw.githubusercontent.com/rook/rook/master/cluster/examples/kubernetes/ceph/cluster.yaml` to create rook cluster
4. Install Rook Tools `kubectl apply -f https://raw.githubusercontent.com/rook/rook/master/cluster/examples/kubernetes/ceph/toolbox.yaml` (refer below)
5. Create storage pools and storage classes `kubectl apply -f kubernetes/db-storageClass`

To access rook Dashboard run `kubectl port-forward -n rook-ceph svc/rook-ceph-mgr-dashboard 8443`

##### Validate Rook is working

```bash
> kubectl -n rook-ceph exec -it $(kubectl -n rook-ceph get pod -l "app=rook-ceph-tools" -o jsonpath='{.items[0].metadata.name}') bash

> ceph status
  cluster:
    id:     f0201385-ae22-4fc5-bf77-1df75efa5b9f
    health: HEALTH_WARN
            Reduced data availability: 1 pg inactive
            Degraded data redundancy: 1 pg undersized
            OSD count 1 < osd_pool_default_size 3

  services:
    mon: 3 daemons, quorum a,b,c (age 16m)
    mgr: a(active, since 4m)
    osd: 1 osds: 1 up (since 4m), 1 in (since 4m)

  data:
    pools:   1 pools, 1 pgs
    objects: 0 objects, 0 B
    usage:   1.0 GiB used, 155 GiB / 156 GiB avail
    pgs:     100.000% pgs not active
             1 undersized+peered
```
