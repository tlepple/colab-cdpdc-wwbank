#!/bin/bash

# define starting dir
starting_dir=`pwd`
echo $starting_dir

###########################################################################################################
# import parameters and utility functions 
###########################################################################################################
#. $starting_dir/provider/azure/demo.properties
. $starting_dir/provider/azure/prereq_utils.sh
. $starting_dir/provider/azure/.info


# function for logging
log() {
    echo "[$(date)]: $*"
    echo "[$(date)]: $*" >> terminate.log
}

#delete the instance(s)
#terminate_all_ec2 

# delete all the prereqs by calling the function
terminate_prereqs
