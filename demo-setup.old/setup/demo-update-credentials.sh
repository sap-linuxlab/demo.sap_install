#!/bin/bash


cat << EOT
Update Azure credentials SAP Deployment demo
=============================================

This script updates the azure credentials in a running AAP Controller.
This script should be used only if you have a permanent controller, where you
want to manage changing Azure subscriptions.

Requirements
============

To run this script you need to have at least the following information at hand:

- Your Azure subscription ID
- Your Azure UserID and Password or a client_id, tenant_id and password
- Access to a Ansible Automation Controller or permission to rollout managed service on Azure

EOT


# Create virtual python environment for deployment
if [[ ! -d ~/.venv/azure ]]; then
   [[ ! -d ~/.venv ]] && mkdir ~/.venv
   python3.9 -m venv ~/.venv/azure
fi
echo "Activate python environment"
source ~/.venv/azure/bin/activate
python -m pip install --upgrade pip 

echo -n "Checking for Ansible ... "
if ! which ansible ; then
 echo "installing ansible in venv"
 python -m pip install ansible
 exit 1
fi
echo -n "Checking for Azure CLI  ... "
if ! which az ; then
 echo "ERROR: please install az cli" 
 echo "see: https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=dnf"
 exit 1
fi
echo -n "Checking for jq ... "
if ! which jq ; then 
  echo "ERROR: please install jq (dnf install jq)"
  exit 1
fi

# TODO Check for local python .venv with all the required modules and ansible

# Check if variables are already defined 
[ -f testenv.tower.sh ] && source testenv.tower.sh

echo ""
[ -z "${SUBSCRIPTION}" ]  && echo -n "Enter Azure Subscription ID :" && read SUBSCRIPTION
[ -z "${CLIENT_ID}" ]     && echo -n "Enter your Azure Client ID  :" && read CLIENT_ID
[ -z "${PASSWORD}" ]      && echo -n "Enter your Azure Secret ID  :" && read PASSWORD
[ -z "${TENANT}" ]        && echo -n "Enter your Azure Tenant ID  :" && read TENANT
[ -z "${RESOURCEGROUP}" ] && echo -n "Enter Azure Resource Group  :" && read RESOURCEGROUP
echo ""

[ -z "${CONTROLLER_HOST}" ]     && echo -n "Enter Controller URL:     " && read CONTROLLER_HOST
[ -z "${CONTROLLER_USERNAME}" ] && echo -n "Enter Controller User:    " && read CONTROLLER_USERNAME
[ -z "${CONTROLLER_PASSWORD}" ] && echo -n "Enter Controller Password:" && read CONTROLLER_PASSWORD 

echo "All requirements set"

# Controller Access
export CONTROLLER_HOST
export CONTROLLER_USERNAME
export CONTROLLER_PASSWORD
# Azure environment
export AZURE_CLIENT_ID=$CLIENT_ID
export AZURE_SECRET=$PASSWORD
export AZURE_TENANT=$TENANT
export AZURE_SUBSCRIPTION_ID=${SUBSCRIPTION}
# run config playbooks

ansible-playbook -i localhost, -v 02-configure-AAP.yml -t new_demo_env \
  -e controller_username=${CONTROLLER_HOST} \
  -e controller_password=${CONTROLLER_PASSWORD} \
  -e controller_hostname=${CONTROLLER_HOSTNAME} \
  -e ansible_python_interpreter=~/.venv/azure/bin/python3 \
  -e azure_cli_id=${CLIENT_ID} \
  -e azure_cli_secret=${PASSWORD} \
  -e azure_tenant=${TENANT} \
  -e az_resourcegroup=${RESOURCEGROUP} \
  -e azure_subscription=${SUBSCRIPTION} \
  -e my_suser="${SAP_SUPPORT_DOWNLOAD_USERNAME}" \
  -e my_spass="${SAP_SUPPORT_DOWNLOAD_PASSWORD}" \
  -e ah_token="${AH_TOKEN}" \
  -e machine_password="" \
  -e machine_user="azureuser"
  

  
echo ""
echo "SAP DEMO Update successful"
echo ""
echo "Now login to $CONTROLLER_HOSTNAME and run the demo"



