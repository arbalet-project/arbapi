#!/usr/bin/env bash

username="pi"           # TODO, not yet taken into account
password="arbalet"
hostname="arbalet"
config="config150pi"
config_joy="joyF710"

pwd=`pwd`
source setup/setup.sh $username $password $hostname $config $config_joy
cd $pwd
