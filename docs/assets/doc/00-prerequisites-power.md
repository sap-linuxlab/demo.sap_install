---
layout: default
title: Power Prerequisites
parent: Home
nav_order: 1
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
