# AWS Containers Immersion Day

## Helper scripts for aws staff facilitating the workshop

The scripts `check-labX.sh` will run some tests to check the participant has done the requested steps for each lab.

The lab* scripts will fast forward a participant (or a facilitator) to help them catch up:

`lab0-setup.sh` - does all the setup and applies the root disk resize fix (see known issues below)

`labX.sh` - will build the repective X lab from the workshop and run the tests

Cleanup/reset

`cleanup-all.sh` will take the participants environment back to the beginning state of the lab.
The labX.sh could then get them back to a particular part of the workshop quickly.


----

## Known issues with lab:

* Without any actions you will run out of space on the root filesystem just after lab 5. To fix either:

* * run `./00-setup/02-resize-osdisk.sh` - which will rezie root disk to 32GB (no reboot required)
* * or just before you start lab 5 run `(docker images -q | xargs docker rmi || true) 2> /dev/null`

* Edits must be done correctly

* If a participant switches terminals some important environment variables will be undefined. Not always obvious (eg. leaves values unset in config files)

* EKS build will fail if for soem reason Cloud9 temporary credentials are still enabled - check with this command:
```bash
aws cloud9 describe-environments --environment-id $C9_PID --query environments[0].managedCredentialsStatus --output text
```

-------

## The workshop default environment

OOTB the workshop provisions stack set: `containersid`

* VPC,subnets, routes, NatGW, an instance profile
* ECS Service, ECS TaskDefinition, Load balancer & target group
* ECR repo for mono & like (empty)
* dynamodb table and endpoint

Cloud9 IDE:  Project-containersid
ECS Cluster: Cluster-containersid
Task def:  Monolith-Definition-containersid:**1** (uses public nginx image)   
ECS Service: containersid-MythicalMonolithService-94G891MF0SXZ
ClouldWatch:  containersid-MythicalMonolithLogGroup-tN9a8V1mSrOA
ECR: containersid-like-8vloc4ntgy1t  (empty)
ECR: containersid-mono-cxdsl3ptepdt  (empty)

-----

## The Labs


## Docker basics

Docker practice commands

----

## LAB01 - docker stuff

Populates mono repo with one image 

---

## LAB02 -  run a standalone task

New version of task definition (Monolith-Definition-containersid:2)- pointing to monolth image above
Run the task - directly - (get it's public ip) - curl http://TASK_PUBLIC_IP_ADDRESS/mysfits
check cloud watch - then stop the task

---

## Lab03 - Use a service for the task definition

Update service to use the (Monolith-Definition-containersid:2) task definition

----

## Lab04 - like microservive

Edit mysfits.py - enable like route 
rebuild docker image  for monolyth (with new like route) - 
push mono image with "nolike" tag
also build the like image - and push to like registry
New task definition for mono (with nolike image)  (Monolith-Definition-containersid:3)
New take definition for like  (containersid-like-tN9a8V1mSrOA:1)
Update mono service - to use task defn (Monolith-Definition-containersid:3)
Create new service for like

----

## Lab05 - Build EKS Cluster

Install pre-reqs
Temp creds off
Launch cluster
Test cluster
[add console access]

----

## Lab06 - Install ALB and K8s console

ALB controller provision
K8s console 

---

## Lab07 deploy monolyth service

DynamoDB policy - for IRSA
Service Account
yaml for monolyth and deploy - includes service type LoadBalancer (port 80)
curl 
update index.html - use alb

----

## Lab08 like microservices, ingress to route

Edit mysfits.py - enable like route

push monolyth nolike
push like
yamp nolike, like
deploy
Create ingress  - type alb / /like
change index.html -> alb

-----
-----

### Typical stack output: 

(Also in workshop-1/cfn-output.json)

DynamoTable	    Table-containersid
EKSCloud9EnvId	https://eu-west-2.console.aws.amazon.com/cloud9/ide/f506bd437c404640ac4d3bcf0b6f973d?region=eu-west-2	
LoadBalancerDNS	alb-containersid-1691883799.eu-west-2.elb.amazonaws.com
ProfileName	    containersid-MythicalProfile-6CBwlzzuuXiX
S3WebsiteURL	http://containersid-mythicalbucket-ycm0sjnvgp13.s3-website.eu-west-2.amazonaws.com
SiteBucket	    containersid-mythicalbucket-ycm0sjnvgp13







