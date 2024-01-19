#!/bin/bash

if [ "$#" -lt 1 ]; then
    echo "[INFO] You have to specify the namespace, optionally followed by the label"
    echo "[INFO] e.g: rm_machines.sh test-k8s-namespace chaimeleon.eu/kubebench=true"
    exit 1
fi

namespace=${1}
label_value="chaimeleon.eu/kubebench=true"
if [ "$#" -eq 2 ]; then
    label_value=${2}
fi
echo "[INFO] Removing all objects with the label '${label_value}' from the namespace '${namespace}'"

echo -e "\n[INFO] Deleting  common resource kinds"
kubectl delete all -n ${namespace} -l ${label_value}
echo -e "\n[INFO] Deleting secrets"
kubectl delete secrets -n ${namespace} -l ${label_value}
echo -e "\n[INFO] Deleting configmaps"
kubectl delete configmaps -n ${namespace} -l ${label_value}