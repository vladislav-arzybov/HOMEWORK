## Project Ansible-Playbook

Ansible Playbook created by ReiVol.

### Prerequisite

- **CentOS 7**
- **Python 2.7.5**
  
### Configure

Refer the file `/group_vars/clickhouse/vars.yml`, `/group_vars/clickhouse/vars.yml` and `/group_vars/lighthouse/vars.yml`  to change the default values.

For example if we need to changed version vector,

vector_version: "0.21.1"


### Install


    # Deploy with ansible playbook
    `ansible-playbook -i inventory/prod.yml site.yml`


### Custom configuration files

To override the default settings files, you need to put your settings in the `templates` directory. The files should be 
named exactly the same as the original ones (vector.toml.j2, nginx.cfg.j2, default.cfg.j2)
