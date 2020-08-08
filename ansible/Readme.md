## Setup Kubernetes Nodes using ansible

### Prerequisite

1. Minium of one VM (Minimum of 2vCPU and 4 GB RAM)
2. Certificate based SSH Connection to all the nodes
3. `root` access to all the nodes
4. [Ansible](https://www.ansible.com/) Installed on the host system

### Create Config File

Create `host` and `vars.yml` file, based on the sample files.

`ansible/hosts`

```properties

server0.example.com
server1.example.com
server2.example.com
server3.example.com
server4.example.com

[main]
server0.example.com

[subordinate]
server1.example.com
server2.example.com
server3.example.com
server4.example.com
```

`ansible/vars.yml`

```yml
SUDO_USER: username
SUDO_USER_PASSWORD: user_password
MASTER_NODE_HOST: master_node_host_or_ip
ansible_sudo_pass: user_password
ansible_password: root_password
token: kubeadm_join_token
```

### Sudo user

Setup sudo user by running following command

```shell
ansible-playbook -i hosts -e @./vars.yml playbooks/add_user.yml
```

### Spin up Nodes

Below command with install docker, setup kubeadm, create master node, and joins other nodes to cluster.

```
ansible-playbook -i hosts -e @./vars.yml playbooks/kubeadm.yml
```
