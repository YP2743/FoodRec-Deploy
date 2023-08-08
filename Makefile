output: setup ping deploy

setup:
        terraform -chdir=Terraform output -raw ssh_private_keys > .local/ansible.pem
        echo -e "[all]\n`terraform -chdir=Terraform output -raw public_ip`" > .local/inventory
        ssh-keyscan -t rsa,dsa,ecdsa,ed25519 `terraform -chdir=Terraform output -raw public_ip` >> ~/.ssh/known_hosts
        sudo chmod 600 .local/ansible.pem
ping:
        ansible -i .local/inventory all -u root --private-key .local/ansible.pem -m ping

deploy:
        ansible-playbook -i .local/inventory -u root --private-key .local/ansible.pem Ansible/Playbook.yaml

connect:
        ssh -i .local/ansible.pem root@`terraform -chdir=Terraform output -raw public_ip`