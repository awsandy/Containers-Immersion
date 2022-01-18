cat << EOF > mythical-ingress.yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: "mythical-mysfits-eks"
  annotations:
    kubernetes.io/ingress.class: alb
    alb.ingress.kubernetes.io/scheme: internet-facing
  labels:
    app: mythical-mysfits-eks
spec:
  rules:
    - http:
        paths:
          - path: /mysfits/*/like
            backend:
              serviceName: "mythical-mysfits-like"
              servicePort: 80
          - path: /*
            backend:
              serviceName: "mythical-mysfits-nolike"
              servicePort: 80
EOF

kubectl apply -f mythical-ingress.yaml
kubectl get ingress/mythical-mysfits-eks
sleep 5
kubectl logs -n kube-system deployments/aws-load-balancer-controller -f
