#!/bin/bash
# Generic Demo Setup Script
#---------------------------

# Redirect all output also in Logfile
LOGFILE=/tmp/AAPsapdemo.$$.log
exec > >(tee -i "${LOGFILE}")
exec 2>&1
#exec >"${LOGFILE}" 2>&1


cat << EOT
Demo Setup for SAP Deployment Automation with Ansible Automation Platform
=========================================================================

This script deploys AAP2 on Azure and propagates the correct playbooks
to quickstart your demo.

Requirements
============

To run this script you need to have at least the following information at hand:

- Your Azure subscription ID
- Your Azure UserID and Password or a client_id, tenant_id and password
- Access to a Ansible Automation Controller or permission to rollout managed service on Azure
- SAP S-User with download permission or accessible NFS-share with SAP Software 
- Access Token to Red Hat Automation Hub

and the following software preinstalled (the script will check and may do it for you)

- ansible-core Ansible CLI
- jq for parsing json
- ansible collection azure.azcollection plus required python libraries
- azure az CLI

EOT

# FUNCTIONS

# Shows progressspinner
# start with spinner&
# stop with spinner stop
spinner() {
    if [[ "${1}" = "stop" ]]; then
      touch /tmp/stopspin
    else
      echo -n "Start building Ansible Controller"
      local delay=0.75;
      local spinstr='|/-\';
      while [[ ! -f /tmp/stopspin ]]; do
          local temp=${spinstr#?};
          printf " [%c]  " "${spinstr}";
          local spinstr=$temp${spinstr%"${temp}"};
          sleep ${delay};
          printf "\b\b\b\b\b\b";
      done;
      printf "    \b\b\b\b"; 
      rm -f /tmp/stopspin
    fi
}

cache_var() {
  ansible -i localhost, localhost \
   -e ansible_connection=local \
   -m lineinfile \
   -a "path=testenv.azure.sh
       state=present
       line=\"export ${1}=${2}\"
       regexp=\"^export ${1}\"
       create=yes" > /dev/null 2>&1
}

#### EMD Functions

# Create virtual python 3.9 environment for deployment
if [[ ! -d ~/.venv/azure ]]; then
   [[ ! -d ~/.venv ]] && mkdir ~/.venv
   echo "Creating python 3.9 venv"
   python3.9 -m venv ~/.venv/azure
fi
echo "Activate python environment"
source ~/.venv/azure/bin/activate
if python -V | awk '{ split($2,A,".") ; if ( A[1]==3 && A[2]>=9) { exit 0 } else { exit 1 }}'; then
  python -m pip install --upgrade pip
else
  echo "ERROR: python environment too old"
  echo "Please remove ~/.venv/azure and install python 3.9 (dnf install python39)"
  exit 1
fi

echo -n "Checking for Ansible ... "
if ! command -v ansible ; then
 echo "installing ansible in venv"
 python -m pip install ansible
 exit 1
fi
echo -n "Checking for Azure CLI  ... "
if ! command -v az ; then
 echo "ERROR: please install az cli" 
 echo "see: https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=dnf"
 exit 1
fi
echo -n "Checking for jq ... "
if ! command -v jq ; then 
  echo "ERROR: please install jq (dnf install jq)"
  exit 1
fi

# Ensure required ansible collections and prereqs are installed
icp=$(ansible-galaxy collection list | awk '( $1 == "#" ) { CP=$2 }
        ( $1 == "azure.azcollection" ) { print CP; exit 0 }')
if [[ -z "${icp}" ]]; then
   icp="${HOME}/.ansible/collections/ansible_collections"
   ansible-galaxy collection install azure.azcollection -p "${icp}"
fi
pip install -r "${icp}/azure/azcollection/requirements-azure.txt" >"${LOGFILE}" 2>&1

[[ -f testenv.azure.sh ]] && source testenv.azure.sh

# TODO: Ensure Automation.Controller or awx.awx collection is installed (needed for configuring AAP)


echo ""
[[ -z "${AH_TOKEN}" ]] && echo "You can generate a Red Hat Automation Token at https://console.redhat.com/ansible/automation-hub/token"
while [[ -z "${AH_TOKEN}" ]]; do
   echo -n "Enter your Red Hat Automation Hub Token: " && read -r AH_TOKEN
   cache_var AH_TOKEN "${AH_TOKEN}"
done
while [[ -z "${SAP_SUPPORT_DOWNLOAD_USERNAME}" ]]; do
  echo -n "Enter your SAP S-User: "; read -r SAP_SUPPORT_DOWNLOAD_USERNAME
  cache_var SAP_SUPPORT_DOWNLOAD_USERNAME "${SAP_SUPPORT_DOWNLOAD_USERNAME}"
done
while [[ -z "${SAP_SUPPORT_DOWNLOAD_PASSWORD}" ]]; do
  echo -n "Enter your SAP S-User password: "; read -r SAP_SUPPORT_DOWNLOAD_PASSWORD
  cache_var SAP_SUPPORT_DOWNLOAD_PASSWORD "${SAP_SUPPORT_DOWNLOAD_PASSWORD}"
done
while [[ -z "${SUBSCRIPTION}" ]]; do
  echo -n "Enter Azure Subscription ID :"; read -r SUBSCRIPTION
  cache_var SUBSCRIPTION "${SUBSCRIPTION}"
  cache_var AZURE_SUBSCRIPTION_ID '${SUBSCRIPTION}'
done

## get Azure service principal
if [[ -z "${CLIENT_ID}" || -z "${PASSWORD}" || -z "${TENANT}" ]]; then
  a=""
  echo -n "Do your have Azure Service Principal Credentials (client_id, tenant_id and password)? [y/N]"; read -r a
  if [[  "${a}" = "y" || "${a}" = "Y" ]]; then
    echo -n "Enter your Azure Client ID "; read -r CLIENT_ID
    echo -n "Enter your Azure Secret ID "; read -r PASSWORD
    echo -n "Enter your Azure Tenant ID "; read -r TENANT
    SPC="{
           \"appId\": \"${CLIENT_ID}\",
           \"password\": \"${PASSWORD}\",
           \"tenant\": \"${TENANT}\"
         }"
  else
    echo "Creating new Service Principal sapdemo for this demo"
    az login
    az account set --subscription "${SUBSCRIPTION}"
    SPC=$(az ad sp create-for-rbac --name ${USER}-sapdemo --role Contributor --scope "/subscriptions/${SUBSCRIPTION}")
    CLIENT_ID=$( echo ${SPC} | jq -r '.appId' )
    PASSWORD=$( echo ${SPC} | jq -r '.password' )
    TENANT=$( echo $SPC | jq -r '.tenant' )
  fi
  cache_var CLIENT_ID "${CLIENT_ID}"
  cache_var PASSWORD "${PASSWORD}"
  cache_var TENANT "${TENANT}"

  cache_var AZURE_CLIENT_ID '${CLIENT_ID}'
  cache_var AZURE_SECRET '${PASSWORD}'
  cache_var AZURE_TENANT '${TENANT}'
fi
export AZURE_CLIENT_ID="${CLIENT_ID}"
export AZURE_SECRET="${PASSWORD}"
export AZURE_TENANT="${TENANT}"
export AZURE_SUBSCRIPTION_ID="${SUBSCRIPTION}"

## get Ansible Controller Credentials

if [[ -z "${CONTROLLER_HOST}" || -z "${CONTROLLER_USERNAME}" || -z "${CONTROLLER_PASSWORD}" ]]; then
  a=""
  echo -n "Do you have a preinstalled AAP Controller [y/N] "; read -r a
  if [[ "${a}" = "y" || "${a}" = "Y" ]]; then
    echo -n "Enter Controller URL:     "; read -r CONTROLLER_HOST
    echo -n "Enter Controller User:    "; read -r CONTROLLER_USERNAME
    echo -n "Enter Controller Password:"; read -r CONTROLLER_PASSWORD
  else
    while [[ -z "${RESOURCEGROUP}" ]]; do
      echo -n "Enter Azure Resource Group Name:"; read -r RESOURCEGROUP
    done
    cache_var RESOURCEGROUP "${RESOURCEGROUP}"
    # run controller deployment
    rg_result=$(az group create --name  "${RESOURCEGROUP}_AAP" --location eastus | tee -a "${LOGFILE}")
    rg_status=$(echo "${rg_result}"| jq -r '.properties.provisioningState' )
    [[ "${rg_status}" != "Succeeded" ]] && echo "ERROR creating Azure Resource group" && exit 1
    echo "Azure Resource Group for AAP Controller: ${aap_group}"
    aap_managedapp_name=$(cat parameters.json | jq -r '.parameters.applicationResourceName.value')
    if az managedapp list -g ${RESOURCEGROUP}_AAP --query "[].name" | grep -qw "${aap_managedapp_name}"; then
      echo "AAP Managed App ${aap_managedapp_name} already deployed"
      echo "Trying to get config"
    else
      echo "Creating AAP from Marketplace"
      echo "Be patient, this can take up to 3hrs"
      echo "Creation started at $(date) - run 'tail -f ${LOGFILE}' in other window to see the output"
      spinner &
      aap_result=$(az deployment group create --name "AnsibleAutomationPlatform" \
                      --resource-group "${RESOURCEGROUP}_AAP" --template-file ./template.json --parameters ./parameters.json | tee -a ${LOGFILE} )
      # touch /tmp/stopspin # stop spinner
      spinner stop
      echo "Creation stopped at $(date)"
      aap_status=$(echo "${aap_result}"| jq -r '.properties.provisioningState' )
      [[ "${aap_status}" != "Succeeded" ]] && echo "ERROR creating Ansible Controller from marketplace" && exit 1
    fi
    CONTROLLER_HOST=$(az managedapp show  -g  ${RESOURCEGROUP}_AAP -n ${aap_managedapp_name} --query outputs.automationControllerUrl.value)
    CONTROLLER_USERNAME="admin"
    CONTROLLER_PASSWORD=$(cat parameters.json | jq -r '.parameters.adminPassword.value')
  fi
  [[ -z "${CONTROLLER_HOST}" ]] && echo "ERROR: Something unexpected went wrong. " && exit 1
  cache_var CONTROLLER_HOST "${CONTROLLER_HOST}"
  cache_var CONTROLLER_USERNAME "${CONTROLLER_USERNAME}"
  cache_var CONTROLLER_PASSWORD "${CONTROLLER_PASSWORD}"
fi

echo "Configure Controller"
ansible-playbook -i localhost, -vv 02-configure-AAP.yml \
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
  -e machine_user="azureuser"

echo ""
echo "Your demo environment is ready"
echo "Log in to ${CONTROLLER_HOST} as admin with password ${CONTROLLER_PASSWORD}"
echo "Assign a subscription"
echo "kick off the workflow '00 - Set up NFS fileserver'"
echo "demo other workflows"
