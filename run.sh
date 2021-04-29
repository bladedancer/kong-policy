#!/bin/sh

echo ======================
echo === Create Cluster ===
echo ======================

k3d cluster delete konggw
k3d cluster create --no-lb --update-default-kubeconfig=false --wait konggw --volume `pwd`/config:/tmp/config --volume `pwd`/policy-plugin:/tmp/plugin
export KUBECONFIG=$(k3d kubeconfig write konggw)
kubectl cluster-info

docker pull kong/kong-gateway:2.3.3.2-alpine

k3d image import --cluster konggw kong/kong-gateway:2.3.3.2-alpine

echo =======================
echo === Installing Kong ===
echo =======================
kubectl create configmap kong --from-file=./config/kong/kong.conf
kubectl create configmap policy-plugin --from-file=./policy-plugin/kong-plugin-policy-0.1.0-1.all.rock
kubectl apply -f deploy/kong

echo "RUN:"
echo "export KUBECONFIG=$(k3d kubeconfig write konggw)"
