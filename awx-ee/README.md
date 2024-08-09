
# Create Build environment

## Install ansible builder

There might be a package available for your platform. If not you can install the latest ansible builder
with the following commands

```bash
python3 -m venv ~/venv-ansible
. ~/venv-ansible/bin/activate
pip install --upgrade pip
pip install ansible ansible-builder ansible-navigator
```

You can install the required collections to check if everything in the requiremenst file is correct with:

```bash
ansible-galaxy collection install -r requirements.yml  --collections-path /usr/share/ansible/collections
```

You can install the python modules to check everything is ok with

```bash
pip install -r requirements.txt
```

After this you have configured this local python environment that is able to run the playbooks from the CLI as well

To create a SAP EE with galaxy collections only run the following command (replace tag with your registry and version):

```bash
ansible-builder build -v3 \
  --tag myregistry/sap-galaxy-ee:version
```

If you want to add supported Automation Hub content, get your Automation Hub token from [here](https://console.redhat.com/ansible/automation-hub/token) and export it in the environment variable `ANSIBLE_GALAXY_SERVER_RH_CERTIFIED_REPO_TOKEN`, login to `registry.redhat.io` with your RedHat credentials and run the following commands:

```bash
export ANSIBLE_GALAXY_SERVER_RH_CERTIFIED_REPO_TOKEN=_your token_
podman login registry.redhat.io
ansible-builder build -v 3 \
  --tag myregistry/sap-rh-ee:version \
  --build-arg ANSIBLE_GALAXY_SERVER_RH_CERTIFIED_REPO_TOKEN \
  -f execution-environment-rh.yml
```

> [!NOTE]
> These building instructions are only tested on Linux.
> These instructions do not work on Apple Silicon for x86 containers.
> If you know how to build cross-platform EEs with ansible builder, feel free to contact me or create a pull request.
