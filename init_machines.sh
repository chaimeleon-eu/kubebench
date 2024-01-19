#!/bin/bash

NAME_PATTERN='#kubebench-name#'

if [ "$#" -lt 2 ]; then
    echo "[INFO] You have to specify the template file and number of instance, followed by the optional template instance name prefix and namespace"
    echo "[INFO] e.g: init_machines.sh my-template.yml 10 bench-launch- test-k8s-namespace"
    exit 1
fi



template_yml=${1}
instances=${2}
namespace="default"
if [ -f "/var/run/secrets/kubernetes.io/serviceaccount/namespace" ]; then
    namespace=$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace)
fi
template_instance_name_prefix="bench-launch-"
echo "[INFO] Preparing to create ${instances} using the description found in ${template_yml}"


if [ "$#" -ge 3 ]; then
    template_instance_name_prefix=${3}
    if [ "$#" -eq 4 ]; then
        namespace=${4}
    fi
fi
echo "[INFO] Using prefix '${template_instance_name_prefix}' when launching the bench"
echo "[INFO] Using the '${namespace}' namespace"


d=$(<${template_yml})
for i in $(seq 1 $instances); do 
    di=${d//${NAME_PATTERN}/"${template_instance_name_prefix}${i}"}
    echo "${di}" | kubectl apply -n ${namespace} -f -
done