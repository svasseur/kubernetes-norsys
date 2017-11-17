#!/bin/bash
scp controller-install.sh core@172.20.19.38:/home/core/controller-install.sh
ssh core@172.20.19.38 'sudo chmod 0755 /home/core/controller-install.sh'
ssh core@172.20.19.38 'sudo ./home/core/controller-install.sh'


scp worker-install39.sh core@172.20.19.39:/home/core/worker-install.sh
ssh core@172.20.19.39 'sudo chmod 0755 /home/core/worker-install.sh'
ssh core@172.20.19.39 'sudo ./home/core/worker-install.sh'

cp worker-install40.sh core@172.20.19.40:/home/core/worker-install.sh
ssh core@172.20.19.40 'sudo chmod 0755 /home/core/worker-install.sh'
ssh core@172.20.19.40 'sudo ./home/core/worker-install.sh'

cp worker-install41.sh core@172.20.19.41:/home/core/worker-install.sh
ssh core@172.20.19.41 'sudo chmod 0755 /home/core/worker-install.sh'
ssh core@172.20.19.41 'sudo ./home/core/worker-install.sh'

cp worker-install42.sh core@172.20.19.42:/home/core/worker-install.sh
ssh core@172.20.19.42 'sudo chmod 0755 /home/core/worker-install.sh'
ssh core@172.20.19.42 'sudo ./home/core/worker-install.sh'
