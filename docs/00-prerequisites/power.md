---
layout: default
title: Power Prerequisites
parent: Platform Prerequisites
nav_order: 2
---
## Prerequisites for the Power Platform

To create this demo you need to have the following information available:

- Admin Access to your Ansible Automation or AWX Controller
- Name or IP Adress of PowerVC
- Access Credentials for PowerVC (to create LPARs and Network)
- A preconfigured OS Image that can be deployed using PowerVC
- Network Ports of PowerVC need to be reachable by Ansible Execution Environment

**Openstack Ports used by PowerVC**

| Port | OpenStack Component Name |
|------|--------------------------|
| 5000 | Keystone                 |
| 8774 | Nova                     |
| 9696 | Neutron                  |
| 9000 | Cinder                   |
| 9292 | Glance                   |

## DNS
This demo assumes you have a DNS Server with static hostentries, where the IP addresses are predefined. It is recommended to use a prefix for the servers you use in this environment, e.g.

```
10.10.10.21 sapdemo21.example.com sapdemo21
10.10.10.22 sapdemo21.example.com sapdemo22
...
```