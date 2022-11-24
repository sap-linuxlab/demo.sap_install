---
layout: default
title: AAP Inventory Config
nav_order: 4
has_children: true
---

# Inventories
Inventories store information on the hosts we want to run our playbooks against.
Those files can be pre-loaded from GitHub, statically or dynamically created.

Depending on the demo we use dynamic or static inventories.
It is recommended to store environment or connection specific variables at the inventory level.

<!-- Need to be done before project setup ? -->

## localhost entry

Create host localhost with the following host variables

```yaml
ansible_connection: local
ansible_python_interpreter: '{{ ansible_playbook_python }}'
```

## Infrastructure specific setup

Select infrastructure specific setup

- [PowerVC](04-inventories/powervc.md)
- [VMware](04-inventories/vmware.md)

