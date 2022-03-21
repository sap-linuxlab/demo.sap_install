#!/bin/bash

# This script configures a linux server as an ansible control node
# for CLI only 
#
# This script checks that python3 is installed and 
# installs ansible from pip
#
# On Fedora or RHEL8.6+ you can also install the ansible-core package

# Paramter
venv=/opt/ansible

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

# Check if you are running this as root
check_root() {
	if [ $(id -u) -ne 0 ]; then
		echo "You have to run this script as root"
		echo "please become root and run again"
		echo ""
		exit 1
	fi
}



########
# 
# main

check_root
check_python

echo "create virtual python ennvironment at $venv"
$PYTHON -m venv $venv
source $venv/bin/activate
$PYTHON -m pip install --upgrade pip
echo "installing ansible"
$PYTHON -m pip install ansible==2.12
$PYTHON -m pip install ansible-navigator




	
