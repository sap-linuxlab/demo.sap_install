#!/bin/bash

# This script configures a linux server as an ansible control node
# for CLI only 
#
# This script checks that python3 is installed and 
# installs ansible from pip
#
# On Fedora or RHEL8.6+ you can also install the ansible-core package

# Where to install python venv for new ansible
set_python_venv() {
	if [ $(id -u) -ne 0 ]; then
		venv=${HOME}/.new-ansible-core
        else
	        venv=/opt/ansible-new	
	fi
}

# Find the python3 command
check_python() {
     if [ -z "${PYTHON}" ]; then
	if p3=$(which python3 2> /dev/null || which python ); then
            if [ $($p3 -V 2>&1 | cut -c8) != "3" ]; then
		echo "ERROR: No Python version 3 found as default"
		echo "please install python3 and add it to your path"
		echo "or set the environment variable PYTHON to your python3"
		echo "installation and rerun this script"
                exit 1
	    else 
		PYTHON=${p3}
	        export PYTHON
            fi
        else
           echo "ERROR: No python installation found"
	   echo "please install python3 and add it to your path"
           echo "or set the environment variable PYTHON to your python3"
           echo "installation and rerun this script"
           exit 1
        fi
     else
       if [ $($PYTHON -V 2>&1 | cut -c8) != "3" ]; then
                echo "ERROR: No Python version 3 defined in PYTHON environment variable"
                echo "please install python3 and add it to your path"
                echo "or set the environment variable PYTHON to your python3"
                echo "installation and rerun this script"
                exit 1
       fi
     fi
}



########
# 
# main

check_python
set_python_venv

echo "create virtual python ennvironment at $venv"
$PYTHON -m venv $venv
source $venv/bin/activate
echo "Updating pip"
${venv}/bin/python -m pip install --upgrade pip  > ${venv}/inst.log 2>&1
echo "Installing ansible 4.10 (ansible-core 2.11)"
${venv}/bin/python -m pip install ansible==4.10 ansible-navigator >>  ${venv}/inst.log 2>&1

echo "Adding Virtual Python environment to ${HOME}/.bashrc"
echo "source $venv/bin/activate" >> ${HOME}/.bashrc

echo "create ansible navigator config"
cat > ${HOME}/.ansible-navigator.yml << EOT
---
ansible-navigator:
   execution-environment:
     container-engine: podman
     enabled: False
   logging:
     level: critical
     append: False
     file: ${venv}/ansible-navigator.log
EOT

echo ""
echo "Ansible Core 2.11 (ansible 4.10) is installed in a virtual python environmnet"
echo "run \"source $venv/bin/activate\" to activate the new ansible or log in again"
echo ""
