
# Create Build environment

## Install ansible builder 

There might be a package available for your platform. If not you can install the latest ansible builder
with the following commands 
```
python3 -m venv ~/bin/venv-ansible
. ~/venv-ansible/bin/activate
pip install --upgrade pip
pip install ansible ansible-builder ansible-navigator
```

You can install the required collections to check if everything in the requiremenst file is correct with:
```
ansible-galaxy collection install -r requirements.yml  --collections-path /usr/share/ansible/collections
```

You can install the python modules to check everything is ok with
```
pip install -r requirements.txt
```

After this you have configured this local python environment that is able to run the playbooks from the CLI as well

Modify the file execution-environment.yml to copy your ansíble config file that is configured to download from Automation Hub.
The run the following command to create your EE Container (replace tag with your registry)

```
ansible-builder build -v3 --tag quay.io/mkoch-redhat/sap-ee:0.0.1 --container-runtime podman -f execution-environment.yml
```

