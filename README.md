# demo.sap-install - PowerVC Branch

This repository contains the demo for deploying on IBM PowerVC with ansible the community.sap_install collection
and how to use this from [AWX](https://github.com/ansible/awx) or [Red Hat Ansible Controller](https://www.ansible.com/products/controller?hsLang=en-us)

## Demo Description

This demo deploys HANA and S/4 servers on a google cloud following this process:
 ![Picture of workflow here](assets/img/workflow.png)

You will find the corresponding playbooks here which implement the steps of the above workflow

### Demo setup

Switch to main branch to read how to deploy Ansible Automation platform on an INtel based server or virtual machine.

To use this demo you need to have the following information available:

- Admin Access to your Ansible Automation or AWX Controller
- Name or IP Adress of PowerVC
- Access Credentials for PowerVC (to create LPARs and Network)
- A preconfigured RHEL Image that can be deployed using PowerVC
- Network Ports of PowerVC need to be reachable by Ansible Execution Environment

#### Openstack Ports used by PowerVC

| Port | OpenStack Component Name |
|------|--------------------------|
| 5000 | Keystone                 |
| 8774 | Nova                     |
| 9696 | Neutron                  |
| 9000 | Cinder                   |
| 9292 | Glance                   |

#### Configure Automation Platform Credentials

#### Required Variables

#### Helpful Tools (playbooks)

### Run the Demo

Login to Controller with your admin credentials


## Additional Documentation

- [AWX Project Google Group](https://groups.google.com/g/awx-project)
- [AWX Project FAQ](https://www.ansible.com/products/awx-project/faq)
