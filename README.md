# Containers-Immersion

Check some stuff - write check scripts

OOTB:

Stack: containersid
VPC,subnets, routes, NatGW
Instance  profile
Service, TaskDefinition, target group
ECR repo - like and mono
dyndb table and endpoint


Stack output

DynamoTable	    Table-containersid
EKSCloud9EnvId	https://eu-west-2.console.aws.amazon.com/cloud9/ide/f506bd437c404640ac4d3bcf0b6f973d?region=eu-west-2	ID of the EKS Lab IDE	-
LoadBalancerDNS	alb-containersid-1691883799.eu-west-2.elb.amazonaws.com	The DNS for the load balancer
ProfileName	    containersid-MythicalProfile-6CBwlzzuuXiX
S3WebsiteURL	http://containersid-mythicalbucket-ycm0sjnvgp13.s3-website.eu-west-2.amazonaws.com	This is the DNS name of your S3 site	-
SiteBucket	    containersid-mythicalbucket-ycm0sjnvgp13	



Cloud9 IDE:  Project-containersid
ECS Cluster: Cluster-containersid

Task def:  Monolith-Definition-containersid
Monolith-Definition-containersid:1 nginx    monolyth-service

Service: containersid-MythicalMonolithService-94G891MF0SXZ
Service task def: Monolith-Definition-containersid:1

---

ClouldWatch
containersid-MythicalMonolithLogGroup-tN9a8V1mSrOA

---
ECR
containersid-like-8vloc4ntgy1t  (empty)
containersid-mono-cxdsl3ptepdt  (empty)

-----

LAB01 - docker stuff
Populates mono repo with one image 

LAB02

New version of task definition (Monolith-Definition-containersid:2)- pointing to monolth image above

Run the task - directly - (get it's public ip) - curl http://TASK_PUBLIC_IP_ADDRESS/mysfits
check cloud watch - then stop the task

---

Lab03

Update service to use the (Monolith-Definition-containersid:2) task definition

----

Lab04

Edit mysfits.py - enable like route 

rebuild docker image  for monolyth (with new like route) - push mono image with "nolike" tag
also build the like image - and push to like registry

New task definition for mono (with nolike image)  (Monolith-Definition-containersid:3)
New take definition for like  (containersid-like-tN9a8V1mSrOA:1)

Update mono service - to use task defn (Monolith-Definition-containersid:3)
Create new service for like

Lab05

Install pre-reqs
Temp creds off
Launch cluster
Test cluster
[add console access]

Lab06
ALB controller provision
K8s console [hmm]

Lab07
DynamoDB policy - for IRSA
Service Account
yaml for monolyth and deploy - includes service type LoadBalancer (port 80)
curl 
update index.html - use alb


Lab08

Edit mysfits.py - enable like route

push monolyth nolike
push like
yamp nolike, like
deploy
Create ingress  - type alb / /like
change index.html -> alb











