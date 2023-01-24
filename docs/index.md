---
layout: default
title: Platform Prerequisites
nav_order: 0
has_children: true
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

* [GCP (WIP)](00-prerequisites/google.md)
* Azure - planned
* [PowerVC](00-prerequisites/power.md)
* Dell - WIP
* HPE - WIP
* [VMware (vCenter Version 6 and 7+)](00-prerequisites/vmware.md)

Click on each platform to explore the prerequisites

### Demo setup

Follow the Documentation to setup your own demo and learn to use these roles

  1. [Installation and Basic Configuration of AWX/AAP2](01-install.md)
  2. [Configure required Credentials](02-credentials.md)
  3. [Configure Projects](03-projects.md)
  4. [Configure Inventories](04-inventories.md)
  5. [Configure Templates](05-templates.md)

### Run the Demo

- Login to Controller with the admin user and password you created.
- Click on `Resources` -> `Templates`
- Launch the `End-2-End S/4 HANA deployment` workflow template

<!-- img src="assets/img/wip.png" width="100" -->


## Additional Documentation

- [Red Hat Ansible Automation Pllatform](https://www.redhat.com/en/technologies/management/ansible)
- [AWX Project Google Group](https://groups.google.com/g/awx-project)
- [AWX Project FAQ](https://www.ansible.com/products/awx-project/faq)
