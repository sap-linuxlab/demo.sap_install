Install Ansible Automation Platform
====================================

1. [Download](https://developers.redhat.com/products/rhel/overview) and [install](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/performing_a_standard_rhel_installation/index) RHEL
2. [Download](https://developers.redhat.com/products/ansible/download)  and [install](https://access.redhat.com/documentation/en-us/red_hat_ansible_automation_platform/2.1/html/red_hat_ansible_automation_platform_installation_guide/index)  Ansible Automation Platform 2.x

NOTE: To access  and use the Red Hat Enterprise Products free of charge, you have to register as developer or Red Hat Partner.

Install AWX
===========

1. Download and install0 [RHEL]((https://developers.redhat.com/products/rhel/overview) or [Fedora Server](https://getfedora.org/en/server/download/)
2. Download and install [Microshift](https://microshift.io/docs/getting-started/)
3. Download and install [awx operator and awx](https://github.com/ansible/awx-operator)

Install Ansible CLI only
========================

run the following command on your linux machine

```
curl https://raw.githubusercontent.com/sap-linuxlab/demo.sap-install/main/tools/setup-cli.sh | bash
```

It will do the following (which you can do manually too):

- check if python3 is installed
  ```
  # python3 -V
  Python 3.6.8
  ```

- create venv in /opt/ansible
  ```
  # python3 -m venv /opt/ansible
  # source /opt/ansible/bin/activate
  ```
- installs ansible-core 2.11+ and ansible-navigator
  ```
  # python3 -m pip install ansible==4.10 ansible-navigator
  ```
- installs proper ansible-navigator config to ${HOME}/.ansible-navigator.yml
  ```
  ---
  ansible-navigator:
    execution-environment:
      container-engine: podman
      enabled: False
    logging:
      level: critical
      append: False
      file: ${venv}/ansible-navigator.log
   ```
