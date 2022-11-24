---
layout: default
title: Home
nav_order: 1
permalink: /
---

#  How to Use Ansible Collection `community.sap_install`

This is a desciption how you can use the collection `community.sap_install` from [AWX](https://github.com/ansible/awx) or [Red Hat Ansible Controller](https://www.ansible.com/products/controller?hsLang=en-us). 

The playbooks used in this description can be found in the github repository at [`https://github.com/sap-linuxlab/demo.sap_install`](`https://github.com/sap-linuxlab/demo.sap_install)

## Description

The following diagram shows the typical installation workflow of SAP HANA and S/4HANA. 
 ![Picture of workflow here](assets/img/workflow.png)

You will find the corresponding playbooks in this repository which implement the steps of the above workflow in the subdirectories named like the platform.
Each playbook is prefixed with number of the steps above.

Currently we have demos for the following platforms:

* [VMware (vCenter Version 6 and 7+)](assets/doc/00-prerequisites-vmware.md)
* [GCP (WIP)](assets/doc/00-prerequisites-gcp.md)
* [PowerVC (WIP)](assets/doc/00-prerequisites-power.md)

Click on each platform to explore the prerequisites

### Demo setup

Follow the Documentation to setup your own demo and learn to use these roles

  1. [Installation and Basic Configuration of AWX/AAP2](assets/doc/01-install.md)
  2. [Configure required Credentials](assets/doc/02-credentials.md)
  3. [Configure Projects](assets/doc/03-projects.md)
  4. [Configure Inventories](assets/doc/04-inventories.md)
  5. [Configure Templates](assets/doc/05-templates.md)

### Run the Demo

- Login to Controller with the admin user and password you created.
- Click on `Resources` -> `Templates`
- Launch the `End-2-End S/4 HANA deployment` workflow template

<!-- img src="assets/img/wip.png" width="100" -->


## Additional Documentation

- [AWX Project Google Group](https://groups.google.com/g/awx-project)
- [AWX Project FAQ](https://www.ansible.com/products/awx-project/faq)
