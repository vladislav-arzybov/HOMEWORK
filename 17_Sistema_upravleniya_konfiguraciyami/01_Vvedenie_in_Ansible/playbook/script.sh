#!/bin/bash
#
echo "docker start"
docker start fedora
docker start centos7
docker start ubuntu
#
ansible-playbook -i inventory/prod.yml site.yml --vault-password-file vault_secret.sh
#
echo "docker stop"
docker stop fedora
docker stop centos7
docker stop ubuntu
