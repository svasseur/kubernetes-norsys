# kubernetes-norsys


Vsphere 5.5



**Installation via Kubernetes Anywhere :** 


[-> github.com kubernetes-anywhere](https://github.com/kubernetes/kubernetes-anywhere)

`docker pull cnastorage/kubernetes-anywhere`

`docker run -it -v /tmp:/tmp --rm --env=« PS1=[container]:\w> «  --net=host cnastorage/kubernetes-anywhere:latest /bin/bash
`



.phase1.vSphere.url=""
.phase1.vSphere.port=
.phase1.vSphere.username=""
.phase1.vSphere.password=""
.phase1.vSphere.insecure=y
.phase1.vSphere.datacenter="Norsys-DC"
.phase1.vSphere.datastore="Datastore-12"
.phase1.vSphere.placement="cluster"
.phase1.vSphere.cluster="Norsys-CL"
.phase1.vSphere.useresourcepool="no"
.phase1.vSphere.vmfolderpath="kubernetes"
.phase1.vSphere.vcpu=4
.phase1.vSphere.memory=8096
.phase1.vSphere.network="Prod"
.phase1.vSphere.template="Templates/KubernetesAnywhereTemplatePhotonOS"
.phase1.vSphere.flannel_net="172.1.0.0/16"


Récuperation du fichier /opt/kubernetes-anywhere/phase1/vsphere/kubernetes/kubeconfig.json pour la configuration de kubectl


**Utilisation de Helm**

Permet de déployer ou d’installer des composants rapidement dans kubernetes.

[https://helm.sh/](https://helm.sh/)


![https://helm.sh/](https://helm.sh/assets/images/helm-logo-microsoft.svg)

`helm init` 

Installe un composant tiller sur le cluster k8s

Vérifier l’installation  avec un `helm version`

Faire un `helm repo update` si lors de l’installation d’un composant retourne une erreur « not found » 

##### Installation de nginx-ingress
Controller Ingress, permet d’exposer les services à l’exterieur.

`helm install stable/nginx-ingress`

##### Installation de kube-lego

kube-lego automatically requests certificates for Kubernetes Ingress resources from Let's Encrypt.


`helm install stable/kube-lego --set config.LEGO_EMAIL=$EMAIL,config.LEGO_URL=https://acme-v01.api.letsencrypt.org/directory
`











