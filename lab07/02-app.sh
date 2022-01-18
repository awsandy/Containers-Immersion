cat << EOF > monolith-app.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
 name: mythical-mysfits-eks
 namespace: default
 labels:
   app: mythical-mysfits-eks
spec:
 replicas: 2
 selector:
   matchLabels:
     app: mythical-mysfits-eks
 template:
   metadata:
     labels:
       app: mythical-mysfits-eks
   spec:
     serviceAccount: mythical-misfit
     containers:
       - name: mythical-mysfits-eks
         image: $MONO_ECR_REPOSITORY_URI:latest
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
 name: mythical-mysfits-eks
 namespace: default
spec:
 type: LoadBalancer
 selector:
   app: mythical-mysfits-eks
 ports:
 -  protocol: TCP
    port: 80
    targetPort: 80
EOF
kubectl apply -f monolith-app.yaml
sleep 5
kubectl get services -o wide