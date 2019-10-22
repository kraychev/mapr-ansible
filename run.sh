#!/bin/sh

echo "Vault password is \"mapr\""
sleep 5s
sh /home/docker/mrstart.sh
ansible-playbook  -i inventory/hosts --ask-vault-pass ./install-mapr.yml
ansible  -i inventory/hosts all  -m shell -a " echo stats | nc localhost 5181 | grep Mode"
sleep 5s
ansible-playbook  -i inventory/hosts  ./mount-cluster.yml

ansible  -i inventory/hosts node1 -m shell -a "maprcli node services -cldb restart -nodes node1 node2"
ansible  -i inventory/hosts node1 -m shell -a "maprcli node services -nfs restart -nodes node1 node2 node3"