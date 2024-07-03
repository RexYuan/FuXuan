Over ethernet:
```bash
./init.sh
ansible-playbook configure_wifi.yml --ask-become-pass --extra-vars "ansible_ssh_port=22"
```

Over wifi:
```bash
ansible-playbook configure_ssh_port.yml --ask-become-pass --extra-vars "ansible_ssh_port=22"
ansible-playbook blacklist_ite_cir.yml --ask-become-pass
ansible-playbook resize_volume_fs.yml --ask-become-pass
ansible-playbook setup_ddns.yml
ansible-playbook install_samba.yml --ask-become-pass
ansible-playbook install_docker.yml --ask-become-pass
ansible-playbook setup_nginx_proxy_manager.yml --ask-become-pass
ansible-playbook setup_pihole.yml --ask-become-pass
ansible-playbook setup_home_assistant.yml --ask-become-pass
ansible-playbook setup_jellyfin.yml --ask-become-pass
ansible-playbook setup_calibre_web.yml --ask-become-pass
ansible-playbook setup_immich.yml --ask-become-pass
# ansible-playbook setup_grafana.yml --ask-become-pass
ansible-playbook setup_lanraragi.yml --ask-become-pass
ansible-playbook setup_uptime_kuma.yml --ask-become-pass
ansible-playbook setup_homepage.yml --ask-become-pass
```
