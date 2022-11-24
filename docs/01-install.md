---
layout: default
title: AAP Installation
nav_order: 1
has_children: false
---

# Installation of Ansible Automation Controller or AWX

This document explains ho to install Ansible Automation Controller or AWX on single server, that is suitable for a demo.
Refer to the documentation for HA or more complex setup scenarios.

## System Requirements

The following settings are recommended

- x86-64 system,
- 4 vCpus
- 16GB memory
- &gt;20GB in `/home/awx`
- &gt;40GB in `/var`

For a single demo this can be also smaller. For sizing details or distributed setups see [2].

## Ansible Automation Controller

### Get the required Red Hat Subscriptions

If you want to use the Red Hat Subscriptions for free you have a couple of options

1. You are a Red Hat Partner and you can obtain free test subscriptions (so called NFRs) from the [partner center](https://partnercenter.redhat.com/NFRPageLayout)  according to your partner level.
2. Apply for your free 16-node developer subscription [here](https://developers.redhat.com/products/rhel/overview).  This free developer subscription grants access to RHEL and Ansible Automation Hub.
3. You or your company has bought the subscriptions for RHEL and Ansible Automation Platform

### Installation steps

1. Make sure your subscriptions are available and activated at the [Red Hat Service Portal](https://access.redhat.com/management/). When you click on the developer subscription you should see this screen followed by a list of products. Among them is `Red Hat Enterprise Linux` and `Ansible Automation Platform`:
![Overview of developer subscription](assets/img/RedhatDeveloperSubscription.png)
2. If not done, download RHEL 8.4 or later from [here](https://access.redhat.com/downloads/content/479)
3. Install and register RHEL on your server. You will find the [Installation Guide](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/performing_a_standard_rhel_9_installation/index) at [1]
4. Download Ansible Automation platform [here](https://access.redhat.com/downloads/content/480)
5. Attach your Ansible Automation Subscription to the server
6. Create credentials for the Red Hat Registry
7. Create your Automation Hub Credentials
8. Update your Inventory file
9.  run `setup.sh -i inventory`
10. Login in and confirm subscription

## Configure Access to Red Hat Automation Hub

1. Create a Automation Hub/Galaxy Credential
2. Assign your credential to the organization
3. Assign your organization to the credential


## AWX

1. Install Fedora or CentOS Stream or RHEL 8.4+
2. [Install Microshift (RPM version)](https://microshift.io/docs/getting-started/)
3. Clone GitHub Operator for AWX
   `git clone https://github.com/ansible/awx-operator`
4. Deploy AWX - Follow the instructions on the GitHub page


## References

[1] [Product Documentation for Red Hat Enterprise Linux](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9)

[2] [Red Hat Ansible Automation Platform Installation Guide](https://access.redhat.com/documentation/en-us/red_hat_ansible_automation_platform/2.2/html-single/red_hat_ansible_automation_platform_installation_guide/index)
