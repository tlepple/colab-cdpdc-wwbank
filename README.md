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

# create a directory in OS for bind mount:
cd ~
mkdir -p ./Documents/aws_stuff/docker_stuff

# create a softlink to this directory
sudo ln -s /Users/$USER/Documents/aws_stuff/docker_stuff ~/pier121

# Create a docker volume to persist data
docker volume create horizon-dc-wwbank-vol1

# Create the docker container
docker run -it \
  --name horizon_dc_wwbank \
  --mount source=horizon-dc-wwbank-vol1,target=/app \
  --mount type=bind,source=/Users/$USER/Documents/aws_stuff/docker_stuff,target=/root/pier121 \
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

BIND_MNT_SOURCE="/Users/<replace with your username>/Documents/aws_stuff/docker_stuff"

AWS_RGION=<your region here>
AMI_ID=<centos ami for your region>

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

---

## Next Steps:

1.  When the above step completes an ssh string will written to the screen and look something like this:
```
 ---------------------------------------------------------------------------------------------------------------------------------------------
          ---------------------------------------------------------------------------------------------------------------------------------------------
          |                  	Bind Mount -- SSH Connection String:                                                                                                            
          ---------------------------------------------------------------------------------------------------------------------------------------------
          ---------------------------------------------------------------------------------------------------------------------------------------------
          |       ssh -o StrictHostKeyChecking=no -o IdentitiesOnly=yes -o UserKnownHostsFile=/dev/null -i ~/pier121/tlepple-us-east-2-i-077d05a895e1bc022-10.0.8.106.pem centos@1.1.1.1         
          ---------------------------------------------------------------------------------------------------------------------------------------------
          ---------------------------------------------------------------------------------------------------------------------------------------------

```

2.  Copy this string and open a new terminal window and paste this into your terminal session.  You are now logged into the command line of the newly created host in the cloud provider.

3.  Follow steps in this repo to install the cluster:  [CDP-DC Install](https://github.com/tlepple/horizon-dc)

---
---

##  Terminate all AWS items: 
* VPC, Security Groups, Route Tables, Subnet, Internet Gateway, PEM File and EC2 Instance.

```
export AWS_ACCESS_KEY_ID=<your key>
export AWS_SECRET_ACCESS_KEY=<your secret key>
export AWS_DEFAULT_REGION=<aws region you want to run in>

cd /app/colab-cdpdc-wwbank
. provider/aws/terminate_everything.sh

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

# inspect volume
docker volume inspect horizon-dc-wwbank-vol1

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

