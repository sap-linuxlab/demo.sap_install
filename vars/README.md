
Example Variable setup for step3 and 4
=======================================

This directory contains sample variable setups that are used to configure and run the
mentionend playbooks. Copy the snippets to a local `groupvars` directory or add it to the templates in Ansible Controller.

You will find full platform specific setups in the according subdirectories

## Prepare the system for HANA installation

The playbook [03-A-sap-hana-prepare.yml](../03-A-sap-hana-prepare.yml) prepares the system to consume HANA.

Use the following variables for this playbook:

```
# sap_general_preconfigure
#-------------------------
sap_general_preconfigure_modify_etc_hosts: false        # do not touch /etc/hosts (it's correct)
sap_general_preconfigure_update: true                   # Update the OS packages if necessary
sap_general_preconfigure_fail_if_reboot_required: false # Don't fail if the system needs a reboot
sap_general_preconfigure_reboot_ok: true                # Reboot the system if needed

# sap_hana_preconfigure
#----------------------
sap_hana_preconfigure_update: true                     # Update the OS packages if necessary
sap_hana_preconfigure_fail_if_reboot_required: false   # Don't fail if the system needs a reboot
sap_hana_preconfigure_reboot_ok: true                  # Reboot the system if needed
```

## Step 3-B: Install SAP HANA

The playbook [03-B-sap-hana-install.yml](../03-B-sap-hana-install.yml) installs SAP HANA. It assumes that the SAP HANA software archives have been downloaded to `/sap-software`, e.g. with the SAP Launchpad module (s. [download-sap-media.yml](../download-sap-media.yml) playbook).
The following parameters are the minimum you need to define to install a single node HANA server. See the role documentation for more customizing options

```
# sap_hana_install
#------------------
sap_hana_install_software_directory: /software-sap
sap_hana_install_common_master_password: "R3dh4t$123"
sap_hana_install_sid: 'RHA'
sap_hana_install_instance_number: "00"
```

## Step 4-A: Prepare the system for S/4HANA or Netweaver installation

The playbook [04-A-sap-netweaver-prepare.yml](../04-A-sap-netweaver-prepare.yml) prepares the system to consume S/4HANA or any other Netweaver based components

Use the following variables to run this playbook

```
# sap_general_preconfigure
#-------------------------
sap_general_preconfigure_modify_etc_hosts: false        # do not touch /etc/hosts (it's correct)
sap_general_preconfigure_update: true                   # Update the OS packages if necessary
sap_general_preconfigure_fail_if_reboot_required: false # Don't fail if the system needs a reboot
sap_general_preconfigure_reboot_ok: true                # Reboot the system if needed

# sap_netweaver_preconfigure
#---------------------------
# No extra variable definition is needed
```

## Step 4-B: Installing S/4HANA Software with SAP Software Provisioning Manager

The playbook [04-B-S4-deployment.yml](../04-B-S4-deployment.yml) installs Software with the SAP Software Provisioning Manager (sapinst). The following variable example installs a single Node S/4HANA instance with the mimium configuration.
It assumes that the SAP S/4HANA software archives have been downloaded to `/sap-software`, e.g. with the SAP Launchpad role.
The directory should contain at minimum archives for the following software:

 - sapcar
 - SWPM
 - SAPEXEDB  
 - SAPEXE  
 - IGS Helper
 - IGS  
 - SAP S/4HANA export files

Then the following parameters are the minimum you need to define to install a single node HANA server. See the role documentation for more installable software and further customizing options

```
# sap_swpm
#------------------
sap_swpm_update_etchosts: false						# Don't touch /etc/hosts

# Product ID for New Installation
sap_swpm_product_catalog_id: NW_ABAP_OneHost:S4HANA2020.CORE.HDB.ABAP   # See role documentation for tested ProductID

sap_swpm_software_path: /sap-software                                   # path to the downloaded archives
sap_swpm_sapcar_path: "{{ sap_swpm_software_path }}"                    # path where the sapcar binary lives
sap_swpm_swpm_path: "{{ sap_swpm_software_path }}"                      # path where SWPM archive lives

# NW Passwords
sap_swpm_master_password: "R3dh4t$123"
sap_swpm_ddic_000_password: "{{ sap_swpm_master_password }}"
# HDB Passwords
sap_swpm_db_system_password: "{{ sap_swpm_master_password }}"
sap_swpm_db_systemdb_password: "{{ sap_swpm_master_password }}"
sap_swpm_db_schema_abap: "SAPHANADB"
sap_swpm_db_schema_abap_password: "{{ sap_swpm_master_password }}"
sap_swpm_db_sidadm_password: "{{ sap_swpm_master_password }}"

# NW Instance Parameters
sap_swpm_sid: S4H
sap_swpm_pas_instance_nr: "01"
sap_swpm_ascs_instance_nr: "02"
sap_swpm_ascs_instance_hostname: "{{ ansible_hostname }}"
sap_swpm_fqdn: "{{ ansible_domain }}"                                  # IMPORTANT: This Variable is only the domain and not the FQDN of the server

# HDB Instance Parameters
# For dual host installation, change the db_host to appropriate value
sap_swpm_db_host: "rha-hana"
sap_swpm_db_sid: RHA
sap_swpm_db_instance_nr: "00"
```
