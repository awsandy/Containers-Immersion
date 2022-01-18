cd /home/ec2-user/environment/amazon-ecs-mythicalmysfits-workshop/workshop-1/
TABLE_NAME=$(jq < cfn-output.json -r '.DynamoTable')
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
          image: <<PUT_YOUR_NOLIKE_IMAGE_ECR_ARN>>
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

TABLE_NAME=$(jq < cfn-output.json -r '.DynamoTable')
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
          image: <<PUT_YOUR_LIKE_IMAGE_ECR_ARN>>
          imagePullPolicy: Always
          ports:
            - containerPort: 80
              protocol: TCP
          env:
            - name: MONOLITH_URL
              value: <<PUT_THE_DNS_NAME_OF_YOUR_ALB>>
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
sleep 5
kubectl logs deployments/mythical-mysfits-nolike
kubectl logs deployments/mythical-mysfits-like
