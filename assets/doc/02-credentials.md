
# Credentials

In Automation Controller/AWX credentials are stored encrypted.
Switch to a branch to find which credentials need to be configured for your platform

## Configure your credential to access Vcenter

1. select `Resources` -> `credentials`
2. click `Add`  and enter the following:
   - Name: _name of your credential_
   - Organization: Select your Organization
   - Credential Taype: VMware vCenter
   - VCenter Host: _IP Adress  or Hostname of vCenter Server_
   - Username: _User with administrative permissions_
   - Password: _ Password for t





## Configure your machine credtial



## Custom Credentials

Input Configutrtation
```yaml


```

Injector Creation
```yaml
---
extra_vars:
  reg_activation_key: '{{ password }}'
  reg_organization_id: '{{ username }}'
```
