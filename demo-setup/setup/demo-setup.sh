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

#### END Functions

[[ -f testenv.azure.sh ]] && source testenv.azure.sh

echo ""
while [[ -z "${EMAIL}" ]]; do
  echo -n "Enter your e-mail address: " && read -r EMAIL
  cache_var EMAIL "${EMAIL}"  
done
echo ""

echo "Checking your Automation Hub Token"
while ! curl https://sso.redhat.com/auth/realms/redhat-external/protocol/openid-connect/token -d grant_type=refresh_token -d client_id="cloud-services" -d refresh_token="$AH_TOKEN" --fail --silent --show-error --output /dev/null; do
      echo "you do not have a valid token"
      echo "You can generate a Red Hat Automation Token at https://console.redhat.com/ansible/automation-hub/token"
      echo -n "Enter your Red Hat Automation Hub Token: " && read -r AH_TOKEN
      cache_var AH_TOKEN "${AH_TOKEN}"
done
echo "Automation Hub Token is valid"

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
done
[[ -z "${AZURE_SUBSCRIPTION_ID}" ]] && cache_var AZURE_SUBSCRIPTION_ID "${SUBSCRIPTION}"

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
    echo "Creating new Service Principal ${EMAIL%%@*}_sapdemo for this demo"
    az login
    az account set --subscription "${SUBSCRIPTION}"
    SPC=$(az ad sp create-for-rbac --name ${EMAIL%%@*}_sapdemo --role Contributor --scope "/subscriptions/${SUBSCRIPTION}")
    CLIENT_ID=$( echo ${SPC} | jq -r '.appId' )
    PASSWORD=$( echo ${SPC} | jq -r '.password' )
    TENANT=$( echo $SPC | jq -r '.tenant' )
    echo "Service principal successfully created"
    echo "Client Id : ${CLIENT_ID}"
    echo "Secret    : ${PASSWORD}"
    echo "Tenant    : ${TENANT}"
  fi
  cache_var CLIENT_ID "${CLIENT_ID}"
  cache_var PASSWORD "${PASSWORD}"
  cache_var TENANT "${TENANT}"

  cache_var AZURE_CLIENT_ID "${CLIENT_ID}"
  cache_var AZURE_SECRET "${PASSWORD}"
  cache_var AZURE_TENANT "${TENANT}"
fi

# Resource Group definition
while [[ -z "${RESOURCEGROUP}" ]]; do
    echo -n "Enter Azure Resource Group Name to hold the virtual machines:"; read -r RESOURCEGROUP
done
cache_var RESOURCEGROUP "${RESOURCEGROUP}"

## get Ansible Controller Credentials
if [[ -z "${CONTROLLER_HOST}" || -z "${CONTROLLER_USERNAME}" || -z "${CONTROLLER_PASSWORD}" ]]; then
  a=""
  echo -n "Do you have already an AAP Controller you want to use [y/N] "; read -r a
  if [[ "${a}" = "y" || "${a}" = "Y" ]]; then
    echo -n "Enter Controller URL:     "; read -r CONTROLLER_HOST
    echo -n "Enter Controller User:    "; read -r CONTROLLER_USERNAME
    echo -n "Enter Controller Password:"; read -r CONTROLLER_PASSWORD
  else
    # Ensure you are logged in to the right account
    if [[ $(az account show --query "id") != "\"${SUBSCRIPTION}\"" ]]; then 
      az login
      az account set --subscription "${SUBSCRIPTION}"
    fi
    # run controller deployment
    echo "Azure Resource Group for AAP Controller: ${RESOURCEGROUP}_AAP"
    while [[ -z "${CONTROLLER_PASSWORD}" ]]; do
      echo -n "Enter Controller Password:"; read -r CONTROLLER_PASSWORD
    done
    CONTROLLER_USERNAME="admin" # A new deployment needs admin -- so overwrite it

    aap_managedapp_name="AAPSapDemo"
    if az managedapp list -g ${RESOURCEGROUP}_AAP --query "[].name" | grep -qw "${aap_managedapp_name}"; then
      echo "AAP Managed App ${aap_managedapp_name} already deployed"
      echo "Trying to get config"
    else
      echo "Creating AAP from Marketplace"
      echo "Be patient, this can take up to 3hrs"
      echo "Creation started at $(date) - run 'tail -f ${LOGFILE}' in other window to see the output"
      ansible-playbook -vv 01-deploy-AAP-from-marketplace.yml \
        -e controller_password="${CONTROLLER_PASSWORD}" \
        -e azure_cli_id="${CLIENT_ID}" \
        -e azure_cli_secret="${PASSWORD}" \
        -e azure_tenant="${TENANT}" \
        -e az_resourcegroup="${RESOURCEGROUP}" \
        -e azure_subscription="${SUBSCRIPTION}"

      DeploymentEngineURL=$(az managedapp show  -g  ${RESOURCEGROUP}_AAP -n ${aap_managedapp_name} --query outputs.deploymentEngineUrl.value)
      ansible-playbook -i localhost, -vv 01-wait-for-https.yml \
        -e controller_hostname="${DeploymentEngineURL}"

      echo ""
      echo ""
      echo "======================================================================================================="
      echo "ATTENTION: The deployment of AAP in Azure is not always reliable"
      echo "There is a way to follow along with the deployment, and track the deployment steps,"
      echo " INCLUDING the ability to 'Restart' from a failed step, instead of completelyDeploymentEngineURL"
      echo ""
      echo "To follow the installation process, please browse to ${DeploymentEngineURL}"
      echo "login with ${CONTROLLER_USERNAME} and password ${CONTROLLER_PASSWORD}"
      echo ""
      echo "If the deployment has failed at a specific step you will have the option to RESTART"
      echo "that step to continue the deployment process"
      echo "========================================================================================================="
      echo ""
      echo ""
    fi
    CONTROLLER_HOST=$(az managedapp show  -g  ${RESOURCEGROUP}_AAP -n ${aap_managedapp_name} --query outputs.automationControllerUrl.value)
  fi
  [[ -z "${CONTROLLER_HOST}" ]] && echo "ERROR: Something unexpected went wrong. " && exit 1
  cache_var CONTROLLER_HOST "${CONTROLLER_HOST}"
  cache_var CONTROLLER_USERNAME "${CONTROLLER_USERNAME}"
  cache_var CONTROLLER_PASSWORD "${CONTROLLER_PASSWORD}"
fi

echo "========================================================================================================="
echo "CONFIGURATION SUMMARY"
echo "========================================================================================================="
echo ""
echo "S-User ID:                        ${SAP_SUPPORT_DOWNLOAD_USERNAME}"
echo -n "S-User password:                  "
if [ ! -z "${SAP_SUPPORT_DOWNLOAD_PASSWORD}" ]; then 
  echo "is set" 
else
  echo "is unset -> demo will fail to download SAP software"
fi
echo -n "Red Hat Automation Hub Token:     "
if [[ -n "${AH_TOKEN}" ]]; then
  echo "is set"
else
  echo "is unset -> demo cannot download collections"
fi 
echo ""
echo "Service Principal:	        ${EMAIL%%@*}_sapdemo"
echo "Azure Subscription:               ${SUBSCRIPTION}"
echo "Azure Client Id:                  ${CLIENT_ID}"
echo "Azure Secret:                     ${PASSWORD}"
echo "Azure Tenant:                     ${TENANT}"
echo ""
echo "Azure Resource Group for servers: ${RESOURCEGROUP}"
echo "Azure Resource Group for AAP:     ${RESOURCEGROUP}_AAP"
echo ""
echo "AAP Controller URL:               ${CONTROLLER_HOST}"
echo "AAP Controller admin user:        ${CONTROLLER_USERNAME}"
echo "AAP Controller password           ${CONTROLLER_PASSWORD}"
echo ""
echo "if any of this content is empty, plase stop and rerun the demo with valid information"
echo ""
echo "========================================================================================================="
echo ""
echo ""
echo "Configure Controller when it is installed"
echo "follow the above procedure to watch and ensure the installation"
echo ""
export AZURE_CLIENT_ID="${CLIENT_ID}"
export AZURE_SECRET="${PASSWORD}"
export AZURE_TENANT="${TENANT}"
export AZURE_SUBSCRIPTION_ID="${SUBSCRIPTION}"

ansible-playbook -i localhost, -vv 01-wait-for-https.yml \
  -e controller_hostname="${CONTROLLER_HOST}"

ansible-playbook -i localhost, -vv 02-configure-AAP.yml \
  -e controller_username="${CONTROLLER_HOST}" \
  -e controller_password="${CONTROLLER_PASSWORD}" \
  -e controller_hostname="${CONTROLLER_HOST}" \
  -e azure_cli_id="${CLIENT_ID}" \
  -e azure_cli_secret="${PASSWORD}" \
  -e azure_tenant="${TENANT}" \
  -e az_resourcegroup="${RESOURCEGROUP}" \
  -e azure_subscription="${SUBSCRIPTION}" \
  -e my_suser="${SAP_SUPPORT_DOWNLOAD_USERNAME}" \
  -e my_spass="${SAP_SUPPORT_DOWNLOAD_PASSWORD}" \
  -e ah_token="${AH_TOKEN}" \
  -e machine_user="azureuser"

echo ""
echo "Your demo environment is ready"
echo "Log in to ${CONTROLLER_HOST} as admin with password ${CONTROLLER_PASSWORD}"
echo "Assign a subscription"
echo "kick off the workflow '00 - Set up NFS fileserver' to download the SAP software"
echo "demo other workflows"
echo "You can login to deployed SAP servers using 'ssh azureuser@<IP>' using the password 'SuperSecretP@ssw0rd.'"
echo ""
echo "to delete the demo remove the above two resourcegroups and the service principal"
