```bash
./init.sh
ansible-playbook configure_ssh_port.yml --ask-become-pass --extra-vars "ansible_ssh_port=22"
ansible-playbook blacklist_ite_cir.yml --ask-become-pass
ansible-playbook git_clone.yml
ansible-playbook setup_ddns.yml
ansible-playbook install_docker.yaml --ask-become-pass
ansible-playbook setup_pihole.yml --ask-become-pass
```
