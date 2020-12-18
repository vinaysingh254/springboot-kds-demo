#!/usr/bin/env sh
echo 'building docker image'
docker build -t springboot-k8s:1.0 .
echo 'deleting existing pod,service and deployment with label springboot-k8s'
kubectl delete all -l run=springboot-k8s
echo 'create kubernates deployment'
kubectl run springboot-k8s --image springboot-k8s:1.0 --port 8080 --image-pull-policy IfNotPresent
echo 'exposing service or creating service'
kubectl expose pod springboot-k8s --type=NodePort
kubectl describe pod springboot-k8s