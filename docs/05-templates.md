---
layout: default
title: AAP Template Config
nav_order: 5
has_children: true
---

# Templates

There are two kinds of templates:

1. **Job Templates**: these are connections to the playbooks. You add the credentials, the inventory, variables etc. on which this playbook should run
2. **Workflow templates**: these are used to orchestrate Job templates, and predefined jobs, such as inventory refresh,  based on success or failure of the previous template

While most of this is generic, the provisioning playbooks are platform specific.
The template and workflow creation is  described in detail for each platform

- [PowerVC](05-templates/powervc.md)
- [VMware](05-templates/vmware.md)

