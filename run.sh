#!/bin/sh

echo "Vault password is \"mapr\""
sleep 5s
ansible-playbook -vvv -i inventory/hosts --ask-vault-pass ./install-mapr.yml
ansible -vvv -i inventory/hosts all  -m shell -a " echo stats | nc localhost 5181 | grep Mode"
ansible-playbook -vvv -i inventory/hosts node1 ./install-license.yml
ansible-playbook -vvv -i inventory/hosts all ./mount-cluster.yml

ansible -vvv -i inventory/hosts node1 -m shell -a "maprcli node services -cldb restart -nodes node1 node2"
ansible -vvv -i inventory/hosts node1 -m shell -a "maprcli node services -nfs restart -nodes node1 node2 node3"

