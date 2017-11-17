#!/bin/bash
openssl genrsa -out ca-key.pem 2048
openssl req -x509 -new -nodes -key ca-key.pem -days 10000 -out ca.pem -subj "/CN=kube-ca"

openssl genrsa -out apiserver-key.pem 2048
openssl req -new -key apiserver-key.pem -out apiserver.csr -subj "/CN=kube-apiserver" -config openssl.cnf
openssl x509 -req -in apiserver.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out apiserver.pem -days 365 -extensions v3_req -extfile openssl.cnf

openssl genrsa -out coreos-kubectl-node01-worker-key.pem 2048
WORKER_IP=172.20.19.39 openssl req -new -key coreos-kubectl-node01-worker-key.pem -out coreos-kubectl-node01-worker.csr -subj "/CN=coreos-kubectl-node01" -config worker-openssl.cnf
WORKER_IP=172.20.19.39 openssl x509 -req -in coreos-kubectl-node01-worker.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out coreos-kubectl-node01-worker.pem -days 365 -extensions v3_req -extfile worker-openssl.cnf

openssl genrsa -out coreos-kubectl-node02-worker-key.pem 2048
WORKER_IP=172.20.19.40 openssl req -new -key coreos-kubectl-node02-worker-key.pem -out coreos-kubectl-node02-worker.csr -subj "/CN=coreos-kubectl-node02" -config worker-openssl.cnf
WORKER_IP=172.20.19.40 openssl x509 -req -in coreos-kubectl-node02-worker.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out coreos-kubectl-node02-worker.pem -days 365 -extensions v3_req -extfile worker-openssl.cnf

openssl genrsa -out coreos-kubectl-node03-worker-key.pem 2048
WORKER_IP=172.20.19.41 openssl req -new -key coreos-kubectl-node03-worker-key.pem -out coreos-kubectl-node03-worker.csr -subj "/CN=coreos-kubectl-node03" -config worker-openssl.cnf
WORKER_IP=172.20.19.41 openssl x509 -req -in coreos-kubectl-node03-worker.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out coreos-kubectl-node03-worker.pem -days 365 -extensions v3_req -extfile worker-openssl.cnf

openssl genrsa -out coreos-kubectl-node04-worker-key.pem 2048
WORKER_IP=172.20.19.42 openssl req -new -key coreos-kubectl-node04-worker-key.pem -out coreos-kubectl-node04-worker.csr -subj "/CN=coreos-kubectl-node04" -config worker-openssl.cnf
WORKER_IP=172.20.19.42 openssl x509 -req -in coreos-kubectl-node04-worker.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out coreos-kubectl-node04-worker.pem -days 365 -extensions v3_req -extfile worker-openssl.cnf

openssl genrsa -out admin-key.pem 2048
openssl req -new -key admin-key.pem -out admin.csr -subj "/CN=kube-admin"
openssl x509 -req -in admin.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out admin.pem -days 365


scp apiserver.pem core@172.20.19.38:/home/core/apiserver.pem
scp apiserver-key.pem core@172.20.19.38:/home/core/apiserver-key.pem
scp ca.pem core@172.20.19.38:/home/core/ca.pem
ssh core@172.20.19.38 'sudo mkdir -p /etc/kubernetes/ssl'
ssh core@172.20.19.38 'sudo mv *.pem /etc/kubernetes/ssl'
ssh core@172.20.19.38 'sudo chmod 600 /etc/kubernetes/ssl/*-key.pem'
ssh core@172.20.19.38 'sudo chown root:root /etc/kubernetes/ssl/*-key.pem'

scp coreos-kubectl-node01-worker.pem core@172.20.19.39:/home/core/coreos-kubectl-node01-worker.pem
scp coreos-kubectl-node01-worker-key.pem core@172.20.19.39:/home/core/coreos-kubectl-node01-worker-key.pem
scp ca.pem core@172.20.19.39:/home/core/ca.pem
ssh core@172.20.19.39 'sudo mkdir -p /etc/kubernetes/ssl'
ssh core@172.20.19.39 'sudo mv *.pem /etc/kubernetes/ssl'
ssh core@172.20.19.39 'sudo chmod 600 /etc/kubernetes/ssl/*-key.pem'
ssh core@172.20.19.39 'sudo chown root:root /etc/kubernetes/ssl/*-key.pem'

scp coreos-kubectl-node02-worker.pem core@172.20.19.40:/home/core/coreos-kubectl-node02-worker.pem
scp coreos-kubectl-node02-worker-key.pem core@172.20.19.40:/home/core/coreos-kubectl-node02-worker-key.pem
scp ca.pem core@172.20.19.40:/home/core/ca.pem
ssh core@172.20.19.40 'sudo mkdir -p /etc/kubernetes/ssl'
ssh core@172.20.19.40 'sudo mv *.pem /etc/kubernetes/ssl'
ssh core@172.20.19.40 'sudo chmod 600 /etc/kubernetes/ssl/*-key.pem'
ssh core@172.20.19.40 'sudo chown root:root /etc/kubernetes/ssl/*-key.pem'

scp coreos-kubectl-node03-worker.pem core@172.20.19.41:/home/core/coreos-kubectl-node03-worker.pem
scp coreos-kubectl-node03-worker-key.pem core@172.20.19.41:/home/core/coreos-kubectl-node03-worker-key.pem
scp ca.pem core@172.20.19.41:/home/core/ca.pem
ssh core@172.20.19.41 'sudo mkdir -p /etc/kubernetes/ssl'
ssh core@172.20.19.41 'sudo mv *.pem /etc/kubernetes/ssl'
ssh core@172.20.19.41 'sudo chmod 600 /etc/kubernetes/ssl/*-key.pem'
ssh core@172.20.19.41 'sudo chown root:root /etc/kubernetes/ssl/*-key.pem'

scp coreos-kubectl-node04-worker.pem core@172.20.19.42:/home/core/coreos-kubectl-node04-worker.pem
scp coreos-kubectl-node04-worker-key.pem core@172.20.19.42:/home/core/coreos-kubectl-node04-worker-key.pem
scp ca.pem core@172.20.19.42:/home/core/ca.pem
ssh core@172.20.19.42 'sudo mkdir -p /etc/kubernetes/ssl'
ssh core@172.20.19.42 'sudo mv *.pem /etc/kubernetes/ssl'
ssh core@172.20.19.42 'sudo chmod 600 /etc/kubernetes/ssl/*-key.pem'
ssh core@172.20.19.42 'sudo chown root:root /etc/kubernetes/ssl/*-key.pem'
