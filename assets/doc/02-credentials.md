
# Credentials

In Automation Controller/AWX credentials are stored encrypted.

In Addition to the standard credentials, you also need some custom credentials.  Lets create the definition for the custom credentials first.

Go to `Administration` -> `Credential Types`

## Credentials to Register Systems to RHN with an Activation Key

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


# SAP S-USer Credentials

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



Switch to a branch to find which credentials need to be configured for your platform

To configure credentials go to  `Resources` -> `credentials`

## Configure your credential to access VCenter


1. click `Add`  and enter the following:
   - Name: _name of your credential_
   - Organization: Select your Organization
   - Credential Type: VMware vCenter
   - VCenter Host: _IP Adress  or Hostname of vCenter Server_
   - Username: _User with administrative permissions_
   - Password: _ Password for t
2. Click `Save`

## Configure your machine credential

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


## Configure your RHN Activation key

1. click `Add`  and enter the following:
    - Name: RHN Activation Key
    - Organization: Select your Organization
    - Credential Type: RHN Activation Key
    - Activation Key: _Your Activation Key_
    - Organization ID: _Your Organization ID_
2. Click `Save`

## Configure Your S-User Credentials

 1. click `Add`  and enter the following:
    - Name: SAP S-User
    - Organization: Select your Organization
    - Credential Type: SAP S-User
    - SAP S-User ID: _S1234567_
    - SAP S-User Password: _Your Password_
2. Click `Save`

## Ansible Automation Hub
If you want to download collections from Red Hat Automation Hub, you need to create a credential for this
1. Click `add` and enter the following:
  - Name: Ansible Automato
    - Organization: Select your Organization
    - Credential Type: Ansible Galaxy/Automation Hub API Token
    - Galaxy Server URL:  _copy from https://console.redhat.com/ansible/automation-hub/token_
    - Auth Server URL: _copy from https://console.redhat.com/ansible/automation-hub/token_
    - API Token: Access Token generated at https://console.redhat.com/ansible/automation-hub/token
2. Click `Save`

In order to use teh token properly go to `Organizations`
- select your Organization
- click `Edit`
- Add the previously created token to the `Galaxy Credentials` field
- Ensure the order is as you want
- Click `Save`
