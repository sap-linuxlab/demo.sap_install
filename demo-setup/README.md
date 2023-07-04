# Configure Azure to run the demo

This README contains the developer files for a container to configure and run the SAP Demo scripts from a managed or pre-installed Ansibe Automation Platform.

## Prerequisites

1. Valid Azure Account to deploy managed AAP on Azure
   (RedHat internal: Deploy "Ansible Automation Platform on Azure" Open Environment)


## Configuration and demo steps

1. create new service principal for use with AAP (or use existing one)

2. Deploy AAP automation template

3. configure AAP with the demo base configuration

4. Create NFS Server/Service and download SAP software

5. run the playbooks with the following demos scenarios
   
   1. HANA plus Netweaver
   2. HANA cluster
   3. HANA upgrade 
   4. SAP Kernel Update


## Build/Update environemnt
To create a proper working image for your environment you have to modify the
template file with the appropriate template for your marketplace app in
`setup/01-deploy-AAP-from-marketplace.yml`.

Then run

```[bash]
docker build .
```
Now tag the file and use it locally or push


## Run for development purpose

Create a file `testenv.docker` with the following content, that would not change:
```
EMAIL=xyz@redhat.com

# AAP Controller credentials
CONTROLLER_USERNAME=admin
CONTROLLER_PASSWORD=<your controller password here min. 12Char>

# S-User credentials
SAP_SUPPORT_DOWNLOAD_USERNAME=S00123456 # Replace with your S-User
SAP_SUPPORT_DOWNLOAD_PASSWORD=< your password here>

# Automation Hub Access
AH_TOKEN=your Automation Hub Token here
```
Then run the following command
```[bash]
docker run --rm -it -h demosetup --name sapdemosetup --env-file ./testenv.docker <containerimage>
```
