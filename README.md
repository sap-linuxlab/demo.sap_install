# demo.sap-install - PowerVC Branch

![WORK IN PROGRESS](assets/img/wip.png)

CAUTION: **Currently this is an usuable copy of the google branch**

This repository contains the demo for deploying on IBM PowerVC with ansible the community.sap_install collection
and how to use this from [AWX](https://github.com/ansible/awx) or [Red Hat Ansible Controller](https://www.ansible.com/products/controller?hsLang=en-us)

## Demo Description

This demo deploys HANA and S/4 servers on a google cloud following this process:
 ![Picture of workflow here](assets/img/workflow.png)

You will find the corresponding playbooks here which implement the steps of the above workflow

### Demo setup

Switch to main branch to read how to deploy Ansible Automation platform on an INtel based server or virtual machine.

To use this demo you need to have the following information available:

- Admin Access to your Ansible Automation or AWX Controller
- Name or IP Adress of PowerVC
- Access Credentials for PowerVC (to create LPARs and Network)
- A preconfigured RHEL Image that can be deployed using PowerVC
- Network Ports of PowerVC need to be reachable by Ansible Execution Environment

#### Openstack Ports used by PowerVC

| Port | OpenStack Component Name |
|------|--------------------------|
| 5000 | Keystone                 |
| 8774 | Nova                     |
| 9696 | Neutron                  |
| 9000 | Cinder                   |
| 9292 | Glance                   |


#### Configure this project in AAP/AWX Controller

1. Login to your AAP/AWX Controller as admin
2. Click `Resources -> Projects`
3. Click `Add`
4. Enter the following parameters:
   - Name: `SAP Install Demo PowerVC`
   - select Organization
   - select Source Control Type `Git`
   - Enter Source Url: `https://github.com/sap-linuxlab/demo.sap-install.git`
   - Enter branch `powervc`
   - Select options as needed
   ![aap-project-screenshot](assets/img/aap-create-project.png)
5. Click `Save`

#### Configure AAP/AWX Credentials fro Power VC

1. Login to your AAP/AWX Controller as admin
2. Click `Resources -> Credentials`
3. Click `Add`
4. Enter the following parameters
   - name: `PowerVC Credential`
   - organization `Default`
   - select Credential Type `OpenStack`
   - Username with permissions to create LPARs etc. in PowerVC
   - Password for this user
   - host authentication URL (e.g. https://my-powervc:5000/v3)
   - Project (Tenant Name)
   - Project Domain Name: `Default`
   - Domain Name: `Default`
   - De-select Verify SSL, if you use self-signed certificates in PowerVC
   ![aap-project-screenshot](assets/img/aap-create-OpenStack-Credential.png)
   You get this infomation by logging into PowerVC and by clicking on the user logo in the top right of PowerVC:<BR>
   ![screenshot PowerVC](assets/img/powervc-info.png)
5. Click Save

| :exclamation:  Please Note              |
|:----------------------------------------|
| In the AAP/AWX credentials you can only define the previous parameters for authentication. <BR>  Define the following dictionary in addition to  the OpenStack credential in case you need additional parameters, e.g. `user_domain_name` for authentication: <BR><pre>     os_add_auth:<br>      auth_url: https://powervc:5000/v3/ # mandatory to repeat<br>      user_domain_name: Default          # additional parameters for auth section </pre> |


#### Test the connection by listing disk images from PowerVC

1. Login to your AAP/AWX Controller as admin
2. Click `Resources -> Templates`
3. Click `Add -> Add Job Template`
4. Enter the following parameters
   - Name: e.g `tool - list disk images`
   - Job Type: `Run`
   - Inventory: An inventory that contains localhost
   - Project: `SAP Install Demo PowerVC`
   - select Playbook: `tools/power_list_diskimages.yml`
   - select Credential `Power VC Credential` from category `OpenStack`
5. Click `Save`
6. Click `Launch`

#### Required Variables for Inventory

#### Configure
#### Helpful Tools (playbooks)

### Run the Demo

Login to Controller with your admin credentials


## Additional Documentation

- [AWX Project Google Group](https://groups.google.com/g/awx-project)
- [AWX Project FAQ](https://www.ansible.com/products/awx-project/faq)
