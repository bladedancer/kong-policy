#!/bin/sh

echo ======================
echo === Create Cluster ===
echo ======================

k3d cluster delete konggw
k3d cluster create --no-lb --update-default-kubeconfig=false --wait konggw --volume `pwd`/config:/tmp/config
export KUBECONFIG=$(k3d kubeconfig write konggw)
kubectl cluster-info

docker pull kong/kong-gateway:2.3.3.2-alpine

k3d image import --cluster konggw kong/kong-gateway:2.3.3.2-alpine

echo =======================
echo === Installing Kong ===
echo =======================
kubectl create configmap kong --from-file=./config/kong/kong.conf
kubectl apply -f deploy/kong

echo "RUN:"
echo "export KUBECONFIG=$(k3d kubeconfig write konggw)"
