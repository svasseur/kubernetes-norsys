Deploy CoreOS VMware
====================

Bash script pour déployer un cluster [CoreOS](https://coreos.com/)  sur vmware ESXi

Ce script permet de créer un cluster CoreOS constitué de:
1 master et 3 worker kubernetes


# Pourquoi ?

Ce script a pour but de déployer facilement une infrastructure de cluster complexe. La création de config-drive (voir documentation CoreOS) ainsi que l'upload sur vcenter étant fastidieuse, ce script permet de faciliter grandement le déploiement de cluster CoreOS.  Ces caractéristiques permettent en cas de crise de redéployer une infrastructure complète avec le moindre effort, il s'inscrit ainsi dans un DRP mais peut également être utilisé à des fins de mise à jour.


# Installation

* Renommer et editer `local.credentials.sample` les hosts ESXI et les nom des datastore peuvent être overrider dans le script de lancement create-cluster.sh

```
$ cp local.credentials.sample local.credentials
$ vi local.credentials
```

* Editer `create-cluster.sh` avec :

  * Les ips du serveur master : **ETCD_IP_ADDRESS_00**
  * hostnames du master  :  **ETCD_HOSTNAME_00**
  * Les ips du noeud GlusterFS pour chaque machine workerbee : **IP_GLUSTERFS**
  * Le datastore utilisé pour chaque machine workerbee : **ESXI_DATASTORE**
  * L'adresse ip de chaque machine nodes : **IP_ADDRESS**
  * Lors d'une première installation retirer l'option `-s` de la commande `deploy_coreos_on_esxi2.sh` de la première VM afin de télécharger les images CoreOS vmware


* Lancer le déploiement du cluster

```
$ ./create-cluster.sh
```

**Note:** Le script demande un password pendant son déroulement, il s'agit du password root ESXI afin de créer la machine virtuelle.


# Sécurité

Les fichiers `master.user-data.yaml` et `node.user-data.yaml` contiennent les spécificités des machines queenbee et workerbee. Les clés ssh des utilisateurs ayant accès au cluster doivent être ajoutés dans ces fichiers (voir documentation CoreOS).

# Mise à jour

Deux solutions permettent de mettre à jour un cluster CoreOS (changement de user-data, d'ip, etc...).

La première est de supprimer le cluster entier et de le redéployer (environ 10min de traitement). Elle nécessitera cependant de redéployer tous les services dans le cluster via un script annexe.

La seconde est d'éteindre les machines et de mettre à jour les fichiers `*.user-data.yaml`. Cette méthode permet de ne pas interrompre le service et convient dans la plupart des cas.

La procédure est la suivante :

* Editer `create-cluster.sh` et ajouter l'option `-u` à `deploy_coreos_on_esxi2.sh`
* Commenter les lignes `deploy_coreos_on_esxi2.sh` des machines qui ne nécessitent pas de mise à jour
* Eteindre la machine concerné par la mise à jour
* Lancer le script `create-cluster.sh`
* Démarrer la machine mise à jour.
