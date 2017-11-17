étape juste aprés la construction du cluster kubernetes



pour le master
--------



génération certificat
```
$ openssl genrsa -out ca-key.pem 2048
$ openssl req -x509 -new -nodes -key ca-key.pem -days 10000 -out ca.pem -subj "/CN=kube-ca"
```

création d'un fichier openssl.cnf

en local
```
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = kubernetes
DNS.2 = kubernetes.default
DNS.3 = kubernetes.default.svc
DNS.4 = kubernetes.default.svc.cluster.local
IP.1 = ${K8S_SERVICE_IP}  
IP.2 = ${MASTER_HOST}     
```

Adresse ip du master  172.20.19.38

ensuite :

```
$ openssl genrsa -out apiserver-key.pem 2048
$ openssl req -new -key apiserver-key.pem -out apiserver.csr -subj "/CN=kube-apiserver" -config openssl.cnf
$ openssl x509 -req -in apiserver.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out apiserver.pem -days 365 -extensions v3_req -extfile openssl.cnf
```

pour les nodes
----------
fichier worker-openssl.cnf

```
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
IP.1 = $ENV::WORKER_IP
```

avec

|{WORKER_FQDN}         |  ${WORKER_IP}  |
| ---------------------|----------------|
|coreos-kubectl-node01  | 172.20.19.39|
|coreos-kubectl-node02  | 172.20.19.40|
|coreos-kubectl-node03  | 172.20.19.41|
|coreos-kubectl-node04  | 172.20.19.42|

A lancer sur chaque node
```
$ openssl genrsa -out ${WORKER_FQDN}-worker-key.pem 2048
$ WORKER_IP=${WORKER_IP} openssl req -new -key ${WORKER_FQDN}-worker-key.pem -out ${WORKER_FQDN}-worker.csr -subj "/CN=${WORKER_FQDN}" -config worker-openssl.cnf
$ WORKER_IP=${WORKER_IP} openssl x509 -req -in ${WORKER_FQDN}-worker.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out ${WORKER_FQDN}-worker.pem -days 365 -extensions v3_req -extfile worker-openssl.cnf
```

cluster administrator keypair
```
$ openssl genrsa -out admin-key.pem 2048
$ openssl req -new -key admin-key.pem -out admin.csr -subj "/CN=kube-admin"
$ openssl x509 -req -in admin.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out admin.pem -days 365
```

mettre les fichiers


CONTROLLER FILES	LOCATION


API Certificate	/etc/kubernetes/ssl/apiserver.pem

API Private Key	/etc/kubernetes/ssl/apiserver-key.pem

CA Certificate	/etc/kubernetes/ssl/ca.pem

WORKER FILES	LOCATION

Worker Certificate	/etc/kubernetes/ssl/worker.pem

Worker Private Key	/etc/kubernetes/ssl/worker-key.pem

CA Certificate	/etc/kubernetes/ssl/ca.pem
