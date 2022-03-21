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
		venv=${HOME}/.ansible-core
        else
	        venv=/opt/ansible	
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
$PYTHON -m pip install --upgrade pip
echo "installing ansible"
$PYTHON -m pip install ansible==4.10 ansible-navigator

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
