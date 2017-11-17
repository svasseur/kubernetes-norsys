#!/bin/bash

kubectl config set-cluster default-cluster --server=https://172.20.19.38 --certificate-authority=ca.pem

kubectl config set-credentials default-admin --certificate-authority=ca.pem --client-key=admin-key.pem --client-certificate=admin.pem

kubectl config set-context default-system --cluster=default-cluster --user=default-admin

kubectl config use-context default-system


# on vérifie

kubectl get nodes
