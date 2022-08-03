# demo.sap-install

This repository contains demos for the community.sap_install collection
and how to use this from [AWX](https://github.com/ansible/awx) or [Red Hat Ansible Controller](https://www.ansible.com/products/controller?hsLang=en-us)

This page is the main branch and the files you see in this branch are only templates for implemention.

## Demo Description

This demo deploys HANA and S/4 servers on a google cloud following this process:
 ![Picture of workflow here](assets/img/workflow.png)

You will find the corresponding playbooks in this repository which implement the steps of the above workflow

For a usable demo please switch to the branch for the platform of your choice. These branches will list more details on the configuration.


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

- [AWX Project Google Group](^https://groups.google.com/g/awx-project)
- [AWX Project FAQ](^https://www.ansible.com/products/awx-project/faq)
