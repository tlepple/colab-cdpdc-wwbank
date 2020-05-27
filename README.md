# Setup Docker Container for CDP-DC WWbank Demo Build

##  The goal of this repo is to setup cloud security components and build out instances.

## Notes:
*  The materials in this repo work with CDP-DC version 7.0.3
*  This was built and tested on Docker Version: 19.03.1
*  This assumes you already have Docker installed


##  Docker Setup steps:

```
# Pull docker image centos 7
docker pull centos:7

# Create a docker volume to persist data
docker volume create horizon-dc-wwbank-vol1

# inspect volume
docker volume inspect horizon-dc-wwbank-vol1

# list volumes
docker volume ls

# Create the docker container
docker run -it \
  --name horizon_dc_wwbank \
  --mount source=horizon-dc-wwbank-vol1,target=/app \
  centos:7 bash 
```

### Pull git repo into this new container to build a new cloud instance

```
#install git
yum install -y git
cd /app
git clone https://github.com/tlepple/colab-cdpdc-wwbank.git
cd /app/colab-cdpdc-wwbank


```

##  Update `demo.properties` with your info for each provider

### AWS File:

```
vi ./provider/aws/demo.properties

OWNER_TAG=<your userid here>
AWS_RGION=<your region here>

# set the docker bind mount properties
BIND_MNT_SOURCE="/Users/<replace with your username>/Documents/aws_scripts/docker_bind_mnt"
BIND_MNT_TARGET="/macmnt"

# I will fix this soon
AMI_ID=<centos ami for your region>

#If you already have a security group and subnet ID set:

setup_prereqs=false and update the values of security group and subnet ID to yours from your VPC.
```

### Azure File:
```
vi ./provider/azure/demo.properties

OWNER_TAG=<your userid here>
AZURE_REGION=<your Azure region>

# set the docker bind mount properties
BIND_MNT_SOURCE="/Users/<replace with your username>/Documents/aws_scripts/docker_bind_mnt"
BIND_MNT_TARGET="/macmnt"
```
---

##  Build your instance:

### Run these commands if building in AWS

```
export AWS_ACCESS_KEY_ID=<your key>
export AWS_SECRET_ACCESS_KEY=<your secret key>
export AWS_DEFAULT_REGION=<aws region you want to run in>

cd /app/colab-cdpdc-wwbank
. bin/setup.sh aws
```

###  Run these commands if building in Azure
```
export AZ_USER=<Azure username>
export AZ_PWD=<Azure password>

cd /app/jumpboxMaster
. bin/setup.sh azure
```
---
---

##  Terminate all AWS items: 
* VPC, Security Groups, Route Tables, Subnet, Internet Gateway, PEM File and EC2 Instance.

```
cd /app/colab-cdpdc-wwbank
. provider/aws/terminate_everything.sh

```

## Terminate just the ec2 instance:

```
cd /app/colab-cdpdc-wwbank
. provider/aws/terminate_ec2.sh

```

---
---

##  Terminate Azure items
```
cd /app/colab-cdpdc-wwbank
. provider/azure/terminate_everything.sh
```

---
---

##  Useful docker command reference:


```
# list all containers on host
docker ps -a

#  start an existing container
docker start horizon_dc_wwbank

# connect to command line of this container
docker exec -it horizon_dc_wwbank bash

#list running container
docker container ls -all

# stop a running container
docker container stop horizon_dc_wwbank

# remove a docker container
docker container rm horizon_dc_wwbank

# list docker volumes
docker volume ls

# remove a docker volume
docker volume rm horizon-dc-wwbank-vol1

```

---
---


## Start a stopped Cloud Instance (Currently only works with AWS)
```
cd /app/colab-cdpdc-wwbank
. bin/start_instance.sh

```

## Stop a running Cloud Instance (Currently only works with AWS):
```
cd /app/colab-cdpdc-wwbank
. bin/stop_instance.sh
```

---
---

##  To allow an IP Address access to server run the command for your provider below:

*  This is only needed if you need access from a different public IP than where you originally created the instance

###  Add IP to AWS instance:
```
cd /app/colab-cdpdc-wwbank
. /provider/aws/add_current_ip_access.sh
```

### Add IP to Azure instance:
```
cd /app/colab-cdpdc-wwbank
. /provider/azure/add_current_ip_access.sh
```
