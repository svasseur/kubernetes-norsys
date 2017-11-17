#!/bin/bash
RUNDIR="$( cd "$( dirname "${BASH_SOURCE[0]:-$$}" )" && pwd )"
PATH=${RUNDIR}/bin:${PATH}
if [[ -f ${RUNDIR}/local.credentials ]]; then
  . ${RUNDIR}/local.credentials
else
  echo "Error: Please create local.credentials file from local.credentials.sample for your local network settings and credentials"
  exit 1
fi
# static hostname and IP address for etcd servers.
# This must be a new unique address for your network.  This can be registered in DNS.
export ETCD_IP_ADDRESS_00=172.20.19.38

export ETCD_HOSTNAME_00=kube-master
# create and power on our etcd instances:+
export ETCD_IP_ADDRESS=$ETCD_IP_ADDRESS_00
export ETCD_HOSTNAME=$ETCD_HOSTNAME_00
export ESXI_DATASTORE=Datastore-12
export ETCD_STATE="MASTER"
# Deploiement
# 1 - creation d'une nouvelle VM
#deploy_coreos_on_esxi2.sh --channel stable  --core_os_hostname=${ETCD_HOSTNAME}  queenbee.user-data.yaml
deploy_coreos_on_esxi2.sh --channel stable --core_os_hostname=${ETCD_HOSTNAME}  master.user-data.yaml
# 2 - utilisation de la VM existante
#deploy_coreos_on_esxi2.sh -u --core_os_hostname=${ETCD_HOSTNAME}  master.user-data.yaml

#export ETCD_IP_ADDRESS=$ETCD_IP_ADDRESS_01
#export ETCD_HOSTNAME=$ETCD_HOSTNAME_01
#export ETCD_STATE="BACKUP"
# 1 - creation d'une nouvelle VM
#deploy_coreos_on_esxi2.sh --channel stable  --core_os_hostname=${ETCD_HOSTNAME}  queenbee.user-data.yaml
# 2 - utilisation de la VM existante
#deploy_coreos_on_esxi2.sh -u --core_os_hostname=${ETCD_HOSTNAME}  queenbee.user-data.yaml
#export ETCD_IP_ADDRESS=$ETCD_IP_ADDRESS_02
#export ETCD_HOSTNAME=$ETCD_HOSTNAME_02
#export ETCD_STATE="BACKUP"
# 1 - creation d'une nouvelle VM
#deploy_coreos_on_esxi2.sh --channel stable  --core_os_hostname=${ETCD_HOSTNAME}  queenbee.user-data.yaml
# 2 - utilisation de la VM existante
#deploy_coreos_on_esxi2.sh -u --core_os_hostname=${ETCD_HOSTNAME}  queenbee.user-data.yaml


#Create every workerber of our cluster and dispatch them through your differents ESXI/Datastore/GlusterFS nodes.
export ESXI_HOST=172.20.19.11
export IP_GLUSTERFS=172.20.19.144
export ESXI_DATASTORE=Datastore-12
export IP_ADDRESS=172.20.19.39

deploy_coreos_on_esxi2.sh --channel stable --core_os_hostname=kubectl-node01 node.user-data.yaml
#deploy_coreos_on_esxi2.sh -u --core_os_hostname=kubectl-node01 node.user-data.yaml

export ESXI_DATASTORE=Datastore-12
export IP_ADDRESS=172.20.19.40
deploy_coreos_on_esxi2.sh --channel stable  --core_os_hostname=kubectl-node02 node.user-data.yaml
#deploy_coreos_on_esxi2.sh -u  --core_os_hostname=kubectl-node02 node.user-data.yaml


export IP_GLUSTERFS=172.20.19.145
export ESXI_DATASTORE=Datastore-12
export IP_ADDRESS=172.20.19.41
deploy_coreos_on_esxi2.sh --channel stable  --core_os_hostname=kubectl-node03 node.user-data.yaml
#deploy_coreos_on_esxi2.sh -u  --core_os_hostname=kubectl-node03 node.user-data.yaml


export ESXI_DATASTORE=Datastore-12
export IP_ADDRESS=172.20.19.42
deploy_coreos_on_esxi2.sh --channel stable  --core_os_hostname=kubectl-node04 node.user-data.yaml
#deploy_coreos_on_esxi2.sh -u  --core_os_hostname=kubectl-node04 node.user-data.yaml
