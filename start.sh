#!/usr/bin/env sh

# delete existing deployment/service
#kubectl delete deployment springboot-k8s
#kubectl delete service springboot-k8s
kubectl delete all -l run=springboot-k8s

# redeploy deployment/service
kubectl apply -f deployment.yaml -f service.yaml