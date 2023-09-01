. ~/.bash_profile
cd ~/environment/amazon-ecs-mythicalmysfits-workshop/workshop-1/app/monolith-service
echo  ${MONO_ECR_REPOSITORY_URI}
echo ${TABLE_NAME}
echo ${AWS_REGION}
ALB=$(kubectl get ing mythical-mysfits-eks -o json | jq -r '.status.loadBalancer.ingress[0].hostname' | grep -v Ingress)
cat << EOF > nolikeservice-app.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mythical-mysfits-nolike
  namespace: default
  labels:
    app: mythical-mysfits-nolike
spec:
  replicas: 2
  selector:
    matchLabels:
      app: mythical-mysfits-nolike
  template:
    metadata:
      labels:
        app: mythical-mysfits-nolike
    spec:
      serviceAccount: mythical-misfit
      containers:
        - name: mythical-mysfits-nolike
          image: ${MONO_ECR_REPOSITORY_URI}:nolike
          imagePullPolicy: Always
          ports:
            - containerPort: 80
              protocol: TCP
          env:
            - name: DDB_TABLE_NAME
              value: ${TABLE_NAME}
            - name: AWS_DEFAULT_REGION
              value: ${AWS_REGION}
---
apiVersion: v1
kind: Service
metadata:
  name: mythical-mysfits-nolike
  namespace: default
spec:
  type: NodePort
  selector:
    app: mythical-mysfits-nolike
  ports:
    -  protocol: TCP
       port: 80
       targetPort: 80
EOF

export LIKE_ECR_REPOSITORY_URI=$(aws ecr describe-repositories | jq -r .repositories[].repositoryUri | grep like)

cat << EOF > likeservice-app.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mythical-mysfits-like
  namespace: default
  labels:
    app: mythical-mysfits-like
spec:
  replicas: 2
  selector:
    matchLabels:
      app: mythical-mysfits-like
  template:
    metadata:
      labels:
        app: mythical-mysfits-like
    spec:
      serviceAccount: mythical-misfit
      containers:
        - name: mythical-mysfits-like
          image: ${LIKE_ECR_REPOSITORY_URI}:latest
          imagePullPolicy: Always
          ports:
            - containerPort: 80
              protocol: TCP
          env:
            - name: MONOLITH_URL
              value: ${ALB}
---
apiVersion: v1
kind: Service
metadata:
  name: mythical-mysfits-like
spec:
  type: NodePort
  selector:
    app: mythical-mysfits-like
  ports:
   -  protocol: TCP
      port: 80
      targetPort: 80
EOF


kubectl apply -f likeservice-app.yaml
kubectl apply -f nolikeservice-app.yaml
sleep 10
echo "check some logs"
kubectl logs deployments/mythical-mysfits-nolike | grep Running
kubectl logs deployments/mythical-mysfits-like | grep Running

