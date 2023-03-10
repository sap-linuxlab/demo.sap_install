---
server_def:
  - name: sapdemohana1
    disk_gb: 500
    mem_mb: 131072
    cpus: 8
    group: hanas
    storage_pools:
      - name: sap
        disks:
          - sdb
        volumes:
          - name: data
            size: "128 GiB"
            mount_point: "/hana/data"
            fs_type: xfs
            state: present
          - name: log
            size: "96 GiB"
            mount_point: "/hana/log"
            fs_type: xfs
            state: present
          - name: shared
            size: "128 GiB"
            mount_point: "/hana/shared"
            fs_type: xfs
            state: present
          - name: sap
            size: "50 GiB"
            mount_point: "/usr/sap"
            state: present

  - name: sapdemohana2
    disk_gb: 500
    mem_mb: 131072
    cpus: 8
    group: hanas
    storage_pools:
      - name: sap
        disks:
          - sdb
        volumes:
          - name: data
            size: "128 GiB"
            mount_point: "/hana/data"
            fs_type: xfs
            state: present
          - name: log
            size: "96 GiB"
            mount_point: "/hana/log"
            fs_type: xfs
            state: present
          - name: shared
            size: "128 GiB"
            mount_point: "/hana/shared"
            fs_type: xfs
            state: present
          - name: sap
            size: "50 GiB"
            mount_point: "/usr/sap"
            state: present
            
  - name: sapdemos4hana
    disk_gb: 250
    group: s4hanas
    storage_pools:
      - name: sap
        disks:
          - sdb
        volumes:
          - name: sap
            size: "50 GiB"
            mount_point: "/usr/sap"
            state: present
          - name: sapmnt
            size: "20 GiB"
            mount_point: "/sapmnt"
            state: present
          - name: swap
            size: "21 GiB"
            fs_type: swap
            mount_options: swap
            state: present
        
# sap_general_preconfigure
#-------------------------
sap_domain: ocp.gscoe.intern
sap_general_preconfigure_modify_etc_hosts: true
sap_general_preconfigure_update: true
sap_general_preconfigure_fail_if_reboot_required: false
sap_general_preconfigure_reboot_ok: true

# sap_hana_preconfigure
#----------------------
sap_hana_preconfigure_update: true
sap_hana_preconfigure_fail_if_reboot_required: false
sap_hana_preconfigure_reboot_ok: true

# sap_netweaver_preconfigure
#---------------------------
# No definition needed

# Path to SAP Software on fileshare
#----------------------------------
# download new HANA version, or S4version -- just put it on the share and change here
sap_hana_version: HANA2SPS06
sap_swpm_product: S4HANA2021.FNDN

# sap_hana_install
#------------------
sap_hana_install_software_directory: "{{ nfs_software_archive_dir }}/{{ sap_hana_version }}"
sap_hana_install_sapcar_filename: SAPCAR
sap_hana_install_software_extract_directory: "/home/sapinst"
sap_hana_install_master_password: "R3dh4t$123"
# The following variables are defined by the survey
sap_hana_sid: "RHA"                  
sap_hana_instance_number: "00"

# sap_install.sap_ha_* (4roles in step 03-CD)
#---------------------
### Cluster Definition
sap_ha_install_pacemaker_cluster_name: cluster1
sap_hana_hacluster_password: 'my_hacluster'

sap_hana_cluster_nodes:
  - node_name: sapdemohana1
    node_ip: "{{ hostvars['sapdemohana1'].ansible_host }}"
    node_role: primary
    hana_site: DC01

  - node_name: sapdemohana2
    node_ip: "{{ hostvars['sapdemohana2'].ansible_host }}"
    node_role: secondary
    hana_site: DC02

sap_ha_set_hana_vip1: 10.14.11.5 ## Change to Virtual IP of cluster (needs to be in hosts or DNS)
## Move the parameter lookup detection to the playbook
sap_pacemaker_stonith_devices:
  - name: "fence_for_vmware"
    agent: "fence_vmware_rest"
    parameters: >
       pcmk_host_list='sapdemohana1,sapdemohana2' ssl_insecure=1 ssl=1
       ipaddr="{{lookup('env', 'VMWARE_HOST')}}"
       login="{{lookup('env','VMWARE_USER')}}"
       passwd="{{lookup('env','VMWARE_PASSWORD')}}"

# sap_swpm (used in step 4B)
#----------
# This currently does not work in all setups (see issues)
sap_swpm_update_etchosts: false

# sap_swpm 
#----------
# Product ID for New Installation
sap_swpm_product_catalog_id: NW_ABAP_OneHost:{{ sap_swpm_product }}.HDB.ABAP
# Software
sap_swpm_software_path: "{{ nfs_software_archive_dir }}/{{ sap_swpm_product }}"
sap_swpm_sapcar_path: "{{ sap_swpm_software_path }}"
sap_swpm_swpm_path: "{{ sap_swpm_software_path }}"

# NW Passwords
sap_swpm_master_password: "R3dh4t$123"
sap_swpm_ddic_000_password: "{{ sap_swpm_master_password }}"
# HDB Passwords
sap_swpm_db_system_password: "{{ sap_swpm_master_password }}"
sap_swpm_db_systemdb_password: "{{ sap_swpm_master_password }}"
sap_swpm_db_schema_abap_password: "{{ sap_swpm_master_password }}"
sap_swpm_db_sidadm_password: "{{ sap_swpm_master_password }}"
# Default Value
#sap_swpm_db_schema_abap: "SAPHANADB"
# NW Instance Parameters
sap_swpm_sid: S4H
sap_swpm_pas_instance_nr: "01"
sap_swpm_ascs_instance_nr: "02"
sap_swpm_ascs_instance_hostname: "{{ ansible_hostname }}"
sap_swpm_fqdn: "{{ ansible_domain }}"
# HDB Instance Parameters
sap_swpm_db_host: "hanavip"
sap_swpm_db_sid: '{{ sap_hana_sid }}'
sap_swpm_db_instance_nr: '{{ sap_hana_instance_number }}'
