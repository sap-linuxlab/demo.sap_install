---
layout: default
title: AAP VMWare Inventory Config
nav_order: 3
parent: AAP Inventory Config
---

# Inventory configuration for VMware

## Base configuration
1. Click `Resources` -> `Inventories`
2. Click `Add` -> `Add inventory`
3. Enter the following parameters
   - **Name**: `SAP Demo`
   - **Organization**: _`Your Organization`_
4. Add the following variables:
   
   ```yaml
   # These variables are valid for all hosts in the VMware environment
   vcenter_validate_certs: no  ## if you use a self signed certificate
   vmware_cluster: _Name of VMware Cluster_
   vmware_datacenter: _Name of VMware Datacenter_
   vmware_datastore: _Name of VMware Datastore_
   vmware_folder: _Name of folder for the VMs_
   vmware_template: Name of the VMware template to clone from (has to be in the VMware datastore for the module to work)
   vmware_network: _VMware Network Name_

   # NFS Share with installation Software
   nfs_software_archive_srv: 1.2.3.4:/SapInst  # NFS Server with SAP Software
   nfs_software_archive_dir: /sapinst  # local mountpoint
   ```

   This demo assumes that you have downloaded the SAP software installation bundles to a fileserver that can be accessed via NFS from the nodes. 
   As the fileserver is used by all host in the inventory you can define it here
  

 5. Click `Save`

If you do not know the name of cluster, datacenter, datastore, folder now, just enter a dummy name and continue.
In the next sections we define some templates to figure out these names.

## Configure dynamic inventories

In the just created inventory click on:
1. Click on `Sources`
2. Click `Add`
3. Enter the following:
   - **Name**: SAP Server
   - **Source**: VMware vCenter
   - **Credential**: _your VCenter Credential_
   - **Host Filter**: `sapdemo.*` - I recommend adding a unique prefix to your servers, e.g. sapdemo, in case there are more servers on the environment, and you only want to pick the demo servers  
   - **Update Options**: overwrite
   - **Source Variables**:
  
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

 With that configuration the hosts are added to the inventory with their names. They are reached through their ip addresses (ansible_host), They are all added to the group `sap` and to the group that is set in the annotation field of the VM. Tags may also be an option and if you set `with_path` to true the machines are grouped by their VMware path

 The playbooks in this demo are written to use the annotation field for grouping. If you want or need to change that, please raise an issue in GitHub and make a suggestion.

>**Question to reader**: If you happen to know how to create tags to VMs when creating VMs with ansible, please leave a comment [here](https://github.com/sap-linuxlab/demo.sap_install/issues/8) 