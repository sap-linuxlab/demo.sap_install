
# Credentials

In Automation Controller/AWX credentials are stored encrypted.
In addition to the standard credentials, the following custom credentials may be needed:

 - Credentials to register Red Hat subsciptions with an activation key
 - Credentials to download SAP software

## Configure Custom Credentials

Go to `Administration` -> `Credential Types`

### Credentials to Register Systems to RHN with an Activation Key

The variables defined here are used in the role `mk_ansible_roles.subscribe_rhn`. You may use other ways to subscribe your RHEL system, then you don't need this.

1. Click `Add`
2. Enter the follwoing:
    - `Name`: SAP S-User
    - Input Configuration
      ```yaml
      fields:
        - id: activationkey
          type: string
          label: Activation Key
          secret: true
        - id: orgid
          type: string
          label: Organization ID
          secret: true
      required:
        - activationkey
        - orgid
      ```
    - Injector Creation:
      ```yaml
      ---
      extra_vars:
        reg_activation_key: '{{ activationkey }}'
        reg_organization_id: '{{ orgid }}'
      ```
3. Click `Save`

This creates a Form for injecting the two variable `reg_activation_key` and `reg_organization_id` to a job template (available to the playbook).
If you want to use username, password and pool id for registration, you can do so. Just create a similar template, injecting the variables `reg_username`, `reg_password` and `reg_pool` or `reg_pool_ids`


### SAP S-USer Credentials

S-User credentials are needed  to download SAP Software

1. Click `Add`
2. Enter the follwoing:
    - `Name`: SAP S-User
    - Input Configuration
      ```yaml
      fields:
        - id: suser_id
          type: string
          label: SAP S-User ID
          secret: false
        - id: suser_password
          type: string
          label: SAP S-USer password
          secret: true
      required:
        - suser_id
        - suser_password
      ```
    - Injector Creation:
      ```yaml
      ---
      extra_vars:
        suser_id: '{{ suser_id }}'
        suser_password: '{{ suser_password }}'
      ```
3. Click `Save`


This credential injects the variables `suser_id` and `suser_password` which are required by the `sap_launchpad` collection


## Configure Credentials

To configure credentials go to  `Resources` -> `credentials`

### machine credential for connection and priviledge escalation

The machine credential is used to login to a server and to gain priviledge escalation.
1. click `Add`  and enter the following:
    - Name: _name of your credential_
    - Organization: Select your Organization
    - Credential Type: Machine
    - `Username` and login credentials (e.g., password, ssh-key etc.) of the connection user
    - `Privilege Escalation Username`: root
    - `Privilege  Escalation Password`: if required
    - `Privilege Escalation Method`: if required, e.g. if you use `root` as your connection user you need to change this to `su`.
2. Click `Save`


### RHN Activation key for subscribing against RHEL

The credential type has been created in the previous section

1. click `Add`  and enter the following:
    - Name: RHN Activation Key
    - Organization: Select your Organization
    - Credential Type: RHN Activation Key
    - Activation Key: _Your Activation Key_
    - Organization ID: _Your Organization ID_
2. Click `Save`

### S-User Credentials

The credential type has been created in the previous section and is used to download SAP software

 1. click `Add`  and enter the following:
    - Name: SAP S-User
    - Organization: Select your Organization
    - Credential Type: SAP S-User
    - SAP S-User ID: _S1234567_
    - SAP S-User Password: _Your Password_
2. Click `Save`

### Ansible Automation Hub

For downloading credentials from Ansible Automation Hub this credential is needed:

1. Click `add` and enter the following:
  - Name: Ansible Automato
    - Organization: Select your Organization
    - Credential Type: Ansible Galaxy/Automation Hub API Token
    - Galaxy Server URL:  _copy from https://console.redhat.com/ansible/automation-hub/token_
    - Auth Server URL: _copy from https://console.redhat.com/ansible/automation-hub/token_
    - API Token: Access Token generated at https://console.redhat.com/ansible/automation-hub/token
2. Click `Save`

In order to use the token properly go to `Organizations`
- select your Organization
- click `Edit`
- Add the previously created token to the `Galaxy Credentials` field
- Ensure the order is as you want
- Click `Save`


### Configure your credential to access VCenter

For connections to VMWare this credential is required

1. click `Add`  and enter the following:
   - Name: _name of your credential_
   - Organization: Select your Organization
   - Credential Type: VMware vCenter
   - VCenter Host: _IP Adress  or Hostname of vCenter Server_
   - Username: _User with administrative permissions_
   - Password: _ Password for t
2. Click `Save`

It injects the environment variables `VMWARE_HOST`, `VMWARE_USER` and `VNMWARE_PASSWORD` to a template.
These variables are used by the vmware collections used in this examples
