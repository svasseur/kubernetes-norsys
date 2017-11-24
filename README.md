# kubernetes-norsys


Installation de d’un cluster Kubernetes sous VSphere 5.5


Choix du type d’installation :

# 1. Coreos
Coreos : la méthode n’est plus maintenu par coreos au profit de la méthode tectonic.
Idéal pour la mise en place de kubernetes sur coreos.

Uitlisation des scripts de déploiements de coreos disponible ici : [www.virtuallyghetto.com](www.virtuallyghetto.com)

Exemples de script dans le repertoire [coreos](https://github.com/svasseur/kubernetes-norsys/tree/master/coreos)


# 2. Tectonic
Utilisation d’une méthode propriétaire pour déployer un cluster kubernetes / coreos.

Necessite une license gratuite pour le déploiement jusqu’a 10 instances.

Déploiement via terraform.

Il faut un serveur ipxe pour récuperer les images coreos, si non disponible il est possible d’utiliser le protocole pxe mais dans ce cas il faut contourner le problème avec la construciton d’un fichier undionly.kpxe comme décrit ici : [http://ipxe.org/download](http://ipxe.org/download)

créer un fichier demo.ipxe

```
#!ipxe
dhcp
chain http://machinededeploiement:8080/boot.ipxe
```

construire l’image ipxe
`make bin/undionly.kpxe EMBED=demo.ipxe`

Pour eviter les problèmes, mettre en place le pxe uniquement pour les adresses mac des machines kubernetes. ( histoire d’eviter l’installation de coreos sur toutes les serveurs de l’entreprise qui pourraient rebooter )

Avantage de tectonic : le dashboard de tectonic est sympa. On se se pose pas la question de la mise en place du controler ingress ( les accés externes sont gérés automatiquement ).

Inconvénient : limitation de la licence gratuite.
Pas simple de mettre en place un provider cloud vpshere.


# 3. Kubernetes Anywhere  






**Installation via Kubernetes Anywhere :**


[-> github.com kubernetes-anywhere](https://github.com/kubernetes/kubernetes-anywhere)

`docker pull cnastorage/kubernetes-anywhere`

`docker run -it -v /tmp:/tmp --rm --env=« PS1=[container]:\w> «  --net=host cnastorage/kubernetes-anywhere:latest /bin/bash
`

`make config`

`make deploy`



Récuperation du fichier /opt/kubernetes-anywhere/phase1/vsphere/kubernetes/kubeconfig.json pour la configuration de kubectl

![](./k8s.png)

Récuperation de l’adresse ip et le port du dashboard sans passer par le kubectl proxy

`kubectl get all -n kube-system | grep dashboard`

`po/kubernetes-dashboard-1019458639-m5vm8       1/1       Running   0          20h`
`svc/kubernetes-dashboard   NodePort    10.0.131.235   <none>        80:30401/TCP    20h`

`kubectl describe pods kubernetes-dashboard-1019458639-m5vm8 -n kube-system | grep Node`
`Node:           kubernetes-node4/172.20.20.214`

le dashboard est accessible sur 172.20.20.214:30401



**Utilisation de Helm**

Permet de déployer ou d’installer des composants rapidement dans kubernetes.

[https://helm.sh/](https://helm.sh/)


![https://helm.sh/](https://helm.sh/assets/images/helm-logo-microsoft.svg)

`helm init`

Installe un composant tiller sur le cluster k8s

Vérifier l’installation  avec un `helm version`

Faire un `helm repo update` si lors de l’installation d’un composant retourne une erreur « not found »

## Installation de nginx-ingress
Controller Ingress, permet d’exposer les services à l’exterieur.

`helm install stable/nginx-ingress --set controller.hostNetwork=true`



## Installation d’un provisionner NFS

en mode daemon

fichier [daemonset.yaml](./kubernetes-anywhere/daemonset.yaml)

`kubectl label node kubernetes-node1  app=nfs-provisioner`

`kubectl create -f daemonset.yaml`

installation de nfs-utils sur les workers Photon OS

`tdnf -y install nfs-utils`

`mount -t nfs 172.20.26.1:/nfs /srv`


## Utilisation des volumes vsphere


#####Fonctionne pour un pod avec un replica = 1

se connecter sur la machine vsphere

`vmkfstools -c 50G /vmfs/volumes/Datastore-12/volumes/kubeVolume.vmdk
`

source dans [httpd3.yaml ](./samples/httpd3.yaml)



      volumes:
       - name: httpd3-persistent-storage
        vsphereVolume:
         volumePath: "[Datastore-12] kubevols/kubeVolume"
         fsType: ext4

###### Volume persistent

ssh dans le vpshere

`vmkfstools -c 5G /vmfs/volumes/Datastore-12/volumes/persistent.vmdk`


     apiVersion: v1
     kind: PersistentVolume
    metadata:
      name: pv001
    spec:
      capacity:
         storage: 5Gi
      accessModes:
        - ReadWriteOnce
      persistentVolumeReclaimPolicy: Retain
      vsphereVolume:
         volumePath: "[Datastore-12] kubevols/persistent"
         fsType: ext4



`kubectl describe pv pv0001`
