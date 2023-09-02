cd lab07
./01*
./02*
./03*
./04*
./05*
cd ~/environment/Containers-Immersion
./check-lab07.sh
cd /home/ec2-user/environment/amazon-ecs-mythicalmysfits-workshop/workshop-1/app/monolith-service
kubectl delete -f monolith-app.yaml
