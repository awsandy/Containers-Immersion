kubectl apply -f likeservice-app.yaml
kubectl get pods #(there should be 4 pods)
kubectl logs deployments/mythical-mysfits-nolike
kubectl logs deployments/mythical-mysfits-like
