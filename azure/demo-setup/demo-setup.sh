#!/bin/bash


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
echo -n "Enter your Red Hat Automation Hub Token: "; read AH_TOKEN
echo -n "Enter your SAP S-User: "; read SAP_SUPPORT_DOWNLOAD_USERNAME
echo -n "Enter your SAP S-User password: "; read SAP_SUPPORT_DOWNLOAD_PASSWORD
echo -n "Enter Azure Subscription ID :"; read SUBSCRIPTION

echo -n "Do your have an Azure Service Prncipal Credentials (client_id, tenant_id and password)? [y/N]"; read a
if [ "$a" -eq "y" -o "$a" -eq "Y" ]; then
  echo -n "Enter your Azure Client ID "; read CLIENT_ID
  echo -n "Enter your Azure Secret ID "; read PASSWORD
  echo -n "Enter your Azure Tenant ID "; read TENANT
  SPC="{ 
         appId: $CLIENT_ID
         password: $PASSWORD
         tenant: $TENANT
       }"
else
  echo "Creating new Service Principal ..."
  echo "Enter your user name"; read u
  az login -u $u
  az account set --subscription ${SUBSCRIPTION}
  SPC=$(az ad sp create-for-rbac --name $u --role Contributor --scope /subscriptions/$SUBSCRIPTION)
fi

a=""
echo "Do you have a preinstalled AAP Controller"; read a
if [ "$a" -eq "y" -o "$a" -eq "Y" ]; then
  echo -n "Enter Controller URL:     "; read CONTROLLER_HOST
  echo -n "Enter Controller User:    "; read CONTROLLER_USERNAME
  echo -n "Enter Controller Password:"; read CONTROLLER_PASSWORD 
else
  echo -m "Enter resource Group Name:"; read RESOURCEGROUP
  # run controller deployment
fi

echo "Configure Controller"
# run config playbook

# Azure
#export AZURE_CLIENT_ID=${CLIENT_ID}
#export AZURE_SECRET=${PASSWORD}
#export AZURE_TENANT=${TENANT}
#export AZURE_SUBSCRIPTION_ID=${SUBSCRIPTION}

