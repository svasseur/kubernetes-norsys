Deploy Kubernetes
====================



On part sur 4 workers  et un master

|{WORKER_FQDN}         |  ${WORKER_IP}  |
| ---------------------|----------------|
|coreos-kubectl-master | 172.20.19.38|
|coreos-kubectl-node01  | 172.20.19.39|
|coreos-kubectl-node02  | 172.20.19.40|
|coreos-kubectl-node03  | 172.20.19.41|
|coreos-kubectl-node04  | 172.20.19.42|


[https://coreos.com/kubernetes/docs/latest/getting-started.html]()

#Déployer les machines coreos

repertoire   [/coreos-vmware-deploy](https://github.com/svasseur/kubernetes-norsys/tree/master/coreos/tls-assets)


# Générer les certificat des machines

repertoire  /tls-assets




# génération du master

`sudo mkdir -p /etc/kubernetes/ssl`


récuperer les fichiers

* /etc/kubernetes/ssl/ca.pem
* /etc/kubernetes/ssl/apiserver.pem
* /etc/kubernetes/ssl/apiserver-key.pem

```
$ sudo chmod 600 /etc/kubernetes/ssl/*-key.pem
$ sudo chown root:root /etc/kubernetes/ssl/*-key.pem
```

récuperation du fichier
lancer le fichier `controller-install.sh`
dans ce fichier

on peut changer la version de kubernetes

`export K8S_VER=v1.7.2_coreos.0`

# génération des nodes

`sudo mkdir -p /etc/kubernetes/ssl`

récuperer les fichiers

* /etc/kubernetes/ssl/ca.pem
* /etc/kubernetes/ssl/${WORKER_FQDN}-worker.pem
* /etc/kubernetes/ssl/${WORKER_FQDN}-worker-key.pem

avec ${WORKER_FQDN} == coreos-kubectl-node0x


```
sudo chmod 600 /etc/kubernetes/ssl/*-key.pem
sudo chown root:root /etc/kubernetes/ssl/*-key.pem
```

récuperation du fichier
lancer le fichier `worker-install.sh`
dans ce fichier

changer le ADVERTISE_IP
172.20.19.39 / 40/ 41/ 42

```
cd /etc/kubernetes/ssl/
sudo ln -s coreos-kubectl-node04-worker.pem worker.pem
sudo ln -s coreos-kubectl-node04-worker-key.pem worker-key.pem
```

```
sudo mkdir -p /etc/kubernetes/ssl
sudo mv *.pem /etc/kubernetes/ssl/
sudo chmod 600 /etc/kubernetes/ssl/*-key.pem
sudo chown root:root /etc/kubernetes/ssl/*-key.pem
chmod 0755 worker-install.sh
sudo ./worker-install.sh
```

`scp controller-install.sh core@172.20.19.38:controller-install.sh`
`scp worker-install.sh core@172.20.19.42:worker-install.sh`


changer le fichier
`sudo vi /etc/kubernetes/manifests/kube-apiserver.yaml`

ajouter les paramètres :

```
- --storage-backend=etcd2
- --storage-media-type=application/json
```


# kubectl


fichier kubectlconfig.sh
 a générer dans le repertoire /tls-assets


`kubectl config set-cluster default-cluster --server=https://172.20.19.38 --certificate-authority=ca.pem`

`kubectl config set-credentials default-admin --certificate-authority=ca.pem --client-key=admin-key.pem --client-certificate=admin.pem`

`kubectl config set-context default-system --cluster=default-cluster --user=default-admin `

`kubectl config use-context default-system`


# update de kubernetes
pour faire un update d’une version
editer le fichier :

`/etc/systemd/system/kubelet.service`

et changer le numéro de version

# ajout add on

DNS

https://kubernetes.io/docs/admin/dns/

fichier dnsadon.yml

`kubectl create -f dnsaddon.yml`


Dashboard

```
kubectl create -f kube-dashboard-rc.yaml
kubectl create -f kube-dashboard-svc.yaml
```

pour ouvrir le dashboard en web
```
kubectl get pods --namespace=kube-system
kubectl port-forward kubernetes-dashboard-v1.6.0-xxxxx 9090 --namespace=kube-system
```
