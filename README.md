```bash
./init.sh
ansible-playbook configure_ssh_port.yml --ask-become-pass --extra-vars "ansible_ssh_port=22"
ansible-playbook blacklist_ite_cir.yml --ask-become-pass
ansible-playbook setup_ddns.yml
ansible-playbook install_samba.yml --ask-become-pass
ansible-playbook install_docker.yml --ask-become-pass
ansible-playbook setup_pihole.yml --ask-become-pass
ansible-playbook setup_home_assistant.yml --ask-become-pass
ansible-playbook setup_jellyfin.yml --ask-become-pass --skip-tags copy
ansible-playbook setup_calibre.yml --ask-become-pass --skip-tags copy
```
