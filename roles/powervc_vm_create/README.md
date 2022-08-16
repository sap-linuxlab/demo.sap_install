Role Name: powervc_vm_create
=========

This role creates a vm aka LPAR in PowerVC

Requirements
------------

Credentials for Openstack need  to be configured in AAP/AWX Controller

PowerVC needs to be configured in the following way:
...

Role Variables
--------------

Variables used , which are defined externally

> os_add_auth: additional parameters which are not defined in OpenStack Credential
> os_availability_zones: created from host list
> os_image_filter: Image to deploy from -> can also be moved to local var
> os_network: Netwrok to deploy to

### name of host to be created -> will be the dns hostname, too
vm_create_name:

### default vm flavor
vm_create_flavor: xlarge

### Group name
vm_group_name:

### Deploy target (defined in availabilty zone)
vm_create_deploy_target:

Dependencies
------------


Example Playbook
----------------


License
-------

Apache 2.0

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).
