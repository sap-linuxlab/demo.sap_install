# Templates

There are two kinds of templates:

1. Job Templates - these are connections to the playbooks. You add the credentials, the inventory, variables etc. on which this playbook should run
2. Workflow templates - these are used to orchestrate Job templates, and pedefined jobs, such as inventory refresh,  based on success or failure of the previous template

How to create workflows woill be described in detail in the different branches of this repository


### Test your configuration

To check proper connection to your VCenter create the following template:

1. Go to `Resources` -> `Templates`
2. Click `Add` -> `Add Job Template`
3. Add the frollowing paramters
   - Name: tool - list datacenter
   - Inventory - you demo inventory
   - Project - your github project
   - Playbook - tools/vmware_list_datacenters.yml
   - Credentials - Vcenter Credentials
4. Click `Save`
5. Click `Launch`

If you have self-signed certificates make sure the variable `vcenter_validate_certs: false` is set. You should have done this in your inventory

If everything goes well you get the name of your Datacenters (in the same way it has to be put in the inventory variable)


# Set up the provisioning playbooks
