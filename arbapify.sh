#!/usr/bin/env bash

if [ "$#" -eq 0 ]; then
    username="pi"           # TODO, not yet taken into account
    password="arbalet"
    hostname="arbalet"
    config="config150pi"
    config_joy="joyF710"
else
    if [ "$#" -ne 5 ]; then
        echo -e "\e[31mUSAGE: $0 user_name user_password hostname json_config_file json_joystick_config_file\e[0m"
        exit
    else
        username=$1
        password=$2
        hostname=$3
        config=$4
        config_joy=$5
    fi
fi

pwd=`pwd`

# Load installing functions
source setup/setup.sh

# Execute installing procedure
script=`realpath $0`
script_path=`dirname $script`
setup_system $hostname
setup_user $username $password
setup_ssh $username $script_path
setup_dependencies
setup_workspace $config $config_joy
setup_arbalet $username

cd $pwd
