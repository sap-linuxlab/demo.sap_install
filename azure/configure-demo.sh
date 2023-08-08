#!/bin/bash
#
# CONFIGURATION OF REDHAT SAP DEMO
#

cat << EOT

Ansible Controller SAP Demo on Azure
====================================

This script configures an Ansible Automation Controller for
use with Microsoft Azure

Please enter the following access credentials:

EOT
echo -n "AAP Controller Host:     "; read CONTROLLER_HOST
echo -n "AAP Controller Username: "; read CONTROLLER_USERNAME
echo -n "AAP Controller Password: "; read CONTROLLER_PASSWORD
echo
echo -n "Azure Client ID :        "; read AZURE_CLIENT_ID
echo -n "Azure Secret :           "; read AZURE_SECRET
echo -n "Azure Tenant :           "; read AZURE_TENANT
echo -n "Azure Subscription :     "; read AZURE_SUBSCRIPTION_ID

