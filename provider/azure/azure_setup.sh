#!/bin/bash

###########################################################################################################
# import parameters and utility functions 
###########################################################################################################
. $starting_dir/provider/azure/demo.properties
. $starting_dir/provider/azure/prereq_utils.sh
. $starting_dir/provider/azure/.info


###########################################################################################################
# Define Functions:
###########################################################################################################

###########################################################################################################
# Main execution starts here
###########################################################################################################

#####################################################
# check if all necessary parameters have been exported
#####################################################
if [ "${AZ_USER}" = "" ] || [ "${AZ_PWD}" = "" ]; then
  log "Azure credentials have not been exported. Please export AZ_USER and AZ_PWD and try again. Exiting..."
  exit 1
fi
if [ "${AZURE_REGION}" = "" ]; then
  log "AZURE_REGION has not been exported.\n\nPlease export AZURE_REGION and try again. Exiting..."
  exit 1
fi


#####################################################
#	Step 1: install the Azure cli
#####################################################
install_azure_cli

login_azure_cli

#####################################################
#       Step 2: install the Azure prereqs
#####################################################
if [ $setup_prereqs = true ]; then 
  create_prereqs
fi

#####################################################
#       Step 3: create azure vm instance 
#####################################################
if [ $setup_onenode = true ]; then
  create_onenode_instance
fi

####################################################
#       Step 4: copy ssh key file to bind mount
#####################################################
#if [ $setup_prereqs = true ]; then
#  replicate_key
#fi

#####################################################
#       Step 5: Add IP address to access list
#####################################################
. $starting_dir/provider/azure/add_current_ip_access.sh

#####################################################
#       Step 6: Generate connection strings
#####################################################
. $starting_dir/provider/azure/echo_conn_strings.sh
