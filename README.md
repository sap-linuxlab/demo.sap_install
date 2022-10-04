# demo.sap-install

This repository contains demos for the community.sap_install collection
and how to use this from [AWX](https://github.com/ansible/awx) or [Red Hat Ansible Controller](https://www.ansible.com/products/controller?hsLang=en-us)

## Demo Description

This demo deploys HANA and S/4 servers following this process:
 ![Picture of workflow here](assets/img/workflow.png)

You will find the corresponding playbooks in this repository which implement the steps of the above workflow in the subdirectories named like the platform.

Currently we have demos for the following platforms:

* VMWare (Vcenter Version 6 and 7+)
* GCP (WIP)
* PowerVC (WIP)

### Demo setup

Follow the Documentation to setup your own demo and learn to use these roles

  1. [Installation and Basic Configuration of AWX/AAP2](assets/doc/01-install.md)
  2. [Configure required Credentials](assets/doc/02-credentials.md)
  3. [Configure Projects](assets/doc/03-projects.md)
  4. [Configure Inventories](assets/doc/04-inventories.md)
  5. [Configure Templates](assets/doc/05-templates.md)

### Run the Demo

Login to Controller with ....

<img src="assets/img/wip.png" width="100">



## Additional Documentation

- [AWX Project Google Group](https://groups.google.com/g/awx-project)
- [AWX Project FAQ](https://www.ansible.com/products/awx-project/faq)
