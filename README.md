# kubernetes-norsys


Vsphere 5.5


Installation via coreos / tectonic : trop lié a tectonic 


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




**Utilisation de Helm**

pour déployer ingress pour donner accés ip externe 

`helm init` 











