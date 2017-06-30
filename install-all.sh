#!/bin/bash

while IFS='' read -r line || [[ -n "$line" ]]; do
    IFS=':'
    array=( $line )
    echo "instance = ${array[0]}"
    echo "ip = ${array[1]}"
    IFS=''

    scp ./install-*.sh ubuntu@${array[1]}:~
    ssh -A ubuntu@${array[1]} sudo bash install-docker.sh < /dev/null
    ssh -A ubuntu@${array[1]} sudo bash install-kubectl.sh < /dev/null
    ssh -A ubuntu@${array[1]} sudo bash install-kubeadm.sh < /dev/null
    echo "Done for ${array[0]}:$?"

done < "$1"

ssh -A ubuntu@keycloack.seb.wescale docker run -p 8080:8080 -e KEYCLOAK_USER=admin -e KEYCLOAK_PASSWORD=admin -d jboss/keycloak
sudo bash install-kubectl.sh < /dev/null


echo "Done"
