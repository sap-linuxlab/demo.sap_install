---
layout: default
title: AAP Power Inventory Config
nav_order: 2
parent: AAP Inventory Config
---

# Inventory configuration for PowerVC

## Base configuration
1. Click `Resources` -> `Inventories`
2. Click `Add` -> `Add inventory`
3. Enter the following parameters
   - **Name**: `SAP Demo`
   - **Organization**: _`Your Organization`_
4. Add the following variables:

   ```yaml
   os_add_auth:
     user_domain_name: Default
   os_image_filter: rhel86
   os_network: "networkname"
   os_network_vnic_type: 'direct'

   os_availability_zones:
     "Name Of Hostgroup": "Name Of Hostgroup"
     "hostname": ":MTMS"

   # NFS Share with installation Software
   nfs_software_archive_srv: 1.2.3.4:/SapInst  # NFS Server with SAP Software
   nfs_software_archive_dir: /sapinst  # local mountpoint
   ```

    - `os_add_auth` might be required if the Openstack Credential requires for PowerVC requires more parameters than the credential provides
    - `os_network_vnic_type`: Use 'direct' for SRIOV and 'normal' for SEA
    - Log in to IBM PowerVC managemnt to get all the other information
      - `os_filter_image`: Images -> ImageList -> Name
      - `os_network`:  Networks -> Name
      - `os_availability_zones`: Hosts -> Hostgroup and Hostlist -> Hostname -> MTMS

   This demo assumes that you have downloaded the SAP software installation bundles to a fileserver that can be accessed via NFS from the nodes. 
   As the fileserver is used by all host in the inventory you can define it here
  
 5. Click `Save`

## Configure dynamic inventories

In the just created inventory click on:
1. Click on `Sources`
2. Click `Add`
3. Enter the following:
   - **Name**: SAP Server
   - **Source**: OpenStack
   - **Credential**: _your OpenStack Credential_
   - **Host Filter**: `sapdemo.*` - I recommend adding a unique prefix to your servers, e.g. _sapdemo_, in case there are more servers on the environment, and you only want to pick the demo servers  
   - **Update Options**: Select Overwrite and Overwrite variables
   - **Source Variables**:

      ```yaml
      all_projects: no
      cache: no
      keyed_groups:
        - key: metadata.group
      ```

 4. Click `Save`

 With that configuration the hosts are added to the inventory with their names. They are reached through their ip addresses (hostvar `ansible_host`), They are all added to the group `Hostgroup` and to the group that is set during the creation as `metadata.group`
