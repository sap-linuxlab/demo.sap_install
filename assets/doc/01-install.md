![Work in Progress](../img/wip.png)

# Installation of Ansible Automation Controller or AWX

This document explains ho to install Ansible Automation Controller or AWX on single server, that is suitable for a demo.
Refer to the documention for HA or more complex setup scenarions.

## System Requirements

The following settings are recommended

- x86-64 syste,
- 4 vCpus
- 16GB memory
- &gt;20GB in `/home/awx`
- &gt;40GB in `/var`

For a single demo this can be also smaller. For sizing details or distributed setups see [2].

## Ansible Automation Controller

1. If you do not have a RHEL subcription available, you can get a free version of RHEL here: https://developers.redhat.com/products/rhel/overview. <br>
Register and follow the steps to download your copy of RHEL.
2. Install and register RHEL on your server. You will find the Installation Guide at [1]
3. If you do not have a Ansible Automation Platform subscription,  navigate to https://www.redhat.com/en/technologies/management/ansible/try-it.<BR>You will receive a 60-day trial subscription
4.  Download Ansible Automation platform [here](https://access.redhat.com/downloads/content/480)
5. Attach your Ansible Automation Subscription to the server
6. Create credentials for the Red Hat Registry
7. Create your Automation Hub Credentials
8. Update your Inventory file
9.  run `setup.sh -i inventory`
10. Login in and confirm subscription

## Configure Access to Red Hat Automation Hub

## AWX

1. Install Fedora or Centos or RHEL 8.4+
2. Install Microshift (RPM version)
3. Clone GitHub Operator for AWX
4. Deploy AWX


## References

[1] [Product Documentation for Red Hat Enterprise Linux](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9)

[2] [Red Hat Ansible Automation Platform Installation Guide](https://access.redhat.com/documentation/en-us/red_hat_ansible_automation_platform/2.2/html-single/red_hat_ansible_automation_platform_installation_guide/index)
