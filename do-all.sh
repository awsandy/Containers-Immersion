cd 00-setup
. ./03-key-env.sh
cd ~/environment/Containers-Immersion
./setup-check.sh
cd lab01-Docker-stuff
./01-docker.sh
cd ~/environment/Containers-Immersion
./check-lab01.sh
cd lab02-ecs-task
./01-task-definition.sh
./02-run-task.sh
cd ~/environment/Containers-Immersion
./check-lab02.sh
cd lab02-ecs-scale
./01*
./02*
cd ~/environment/Containers-Immersion
./check-lab03.sh
cd lab04-microservices
./01*
./02*
./03*
./04*
./05*
./06*
cd ~/environment/Containers-Immersion
./check-lab04.sh

cd ~/environment/Containers-Immersion
./check-lab05.sh

cd ~/environment/Containers-Immersion
./check-lab06.sh

cd ~/environment/Containers-Immersion
./check-lab07.sh

cd ~/environment/Containers-Immersion
./check-lab08.sh
echo "Done"