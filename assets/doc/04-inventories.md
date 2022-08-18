
# Inventories
Inventories store information on the hosts we want to run our playbooks against.
Those files can be preloaded from github, staticly or dynamically created

Depending on the demo we use dynamic or static inventories. Please switch to the branch of your platform for more details

You can also define environment and connection specific variables here. Switch to your branch of choice to see what needs to be configured

// Need to be done before project setup !!!
# Create localhost entry

Create host localhost with the following host variables

```yaml
ansible_connection: local
ansible_python_interpreter: '{{ ansible_playbook_python }}'
```

# Configure your inventory for use with VMWare hosts

1. Click `Resources` -> `Ìnventories`
2. Click `Add` -> `Add inventory`
3. Click `Sources` -> `Add`
4. Enter the following parameters
   - Name: _Enter a Name_
   - Source: `VMware vCenter`
   - Credential: _Select your previously defined Vmware credential_
5. Configure your source Variables

```yaml
---
with_path: false
properties:
- "name"
- "config.hardware.numCPU"
- "config.name"
- "config.uuid"
- "guest.ipAddress"
- "runtime.maxMemoryUsage"
- "guest.guestId"
- "config.annotation"
hostnames:
- config.name
compose:
  ansible_host: 'guest.ipAddress'
groups:
  sap: true
keyed_groups:
- key: config.annotation
  separator: ''
  ```
## Configuration Variables:

These variables are valid for all hosts in the VMware environment.
Hence it is good to put them to the inventory

```yaml
vcenter_validate_certs: false      # If you have self-signed certificates
vmware_cluster: "name of cluster"
vmware_datacenter: "name of datacenter"
vmware_datastore: "name of datastore"
vmware_folder: "folder that contains the VMs"
vmware_template: "name of template"
vmware_network: "network name"
```

# Variables for registration => Should move to custom credential
sap_rhsm_activationkey: emeape-training
sap_rhsm_org_id: 6169558

# NFS Share with installation Software
nfs_software_archive_srv: 10.10.4.61:/SapInst
nfs_software_archive_dir: /sapinst
