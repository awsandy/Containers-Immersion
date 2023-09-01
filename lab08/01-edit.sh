kubectl delete deployment mythical-mysfits-eks 2> /dev/null
echo "editing/replacing mythicalMysfitsService.py"
mv ~/environment/amazon-ecs-mythicalmysfits-workshop/workshop-1/app/monolith-service/service/mythicalMysfitsService.py \
~/environment/amazon-ecs-mythicalmysfits-workshop/workshop-1/app/monolith-service/service/mythicalMysfitsService.py.orig
cp ~/environment//Containers-Immersion/lab08/mythicalMysfitsService.py ~/environment/amazon-ecs-mythicalmysfits-workshop/workshop-1/app/monolith-service/service/mythicalMysfitsService.py