```bash
./init.sh
ansible-playbook configure_ssh_port.yml --ask-become-pass --extra-vars "ansible_ssh_port=22"
ansible-playbook blacklist_ite_cir.yml --ask-become-pass
ansible-playbook git_clone.yml
ansible-playbook setup_cron.yml
```
