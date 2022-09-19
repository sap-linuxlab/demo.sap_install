
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

## Base configuration
1. Click `Resources` -> `Ìnventories`
2. Click `Add` -> `Add inventory`
3. Click `Sources` -> `Add`
4. Enter the following parameters
   - Name: `SAP Demo`
   - Source: `VMware vCenter`
   - Credential: _Select your previously defined Vmware credential_
5. Add the following variables:
   ```yaml
   # These variables are valid for all hosts in the VMware environment
   vcenter_validate_certs: no  ## if you use a self signed certifcate
   vmware_cluster: _Name of VMWare Cluster_
   vmware_datacenter: _Name of VMWare Datacenter_
   vmware_datastore: _Name of VMWare Datastore_
   vmware_folder: _Name of folder for the VMs_
   vmware_template: Name of the VMWare template to clone from (has to be in the VMWare datastore for the module to work)
   vmware_network: _VMWare Network Name_

   # NFS Share with installation Software
   nfs_software_archive_srv: 1.2.3.4:/SapInst  # NFS Server with SAP Software
   nfs_software_archive_dir: /sapinst  # local mountpoint
 6. Click `Save`

## Configure dynamic inventories

In the just created inventory click on:
1. Click on `Sources`
2. Click `Add`
3. Enter the following:
   - Name: SAP Server
   - Source: VMWare Vcenter
   - Credential: _your VCenter Credential_
   - Host Filter: `sapdemo-.*`  I recommed adding a unique prefix to your servers, e.g. sapdemo, in case there are more servers on the environment, and you only want to pick the demo servers  
   - Update Options: overwrite
   - Source Variables:
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
 4. Click `Save`

 With that configuration the hosts are added to the inventory with their names. They are reached through their ip adresses (ansible_host), They are all added to the group `sap` and to the group that is set in the annotation field of the VM. Tags may also be an option and if you set `with_path` to true the machines are grouped by their VMware path

 The playbooks in this demo are written to use the annotation field for grouping. If you want or need to chnage that, please raise an issue in github and make a suggestion.
