#!/bin/bash

NAME_PATTERN='#kubebench-name#'

if [ "$#" -lt 2 ]; then
    echo "[INFO] You have to specify the template file and number of instance, followed by the optional template instance name prefix and namespace"
    echo "[INFO] e.g: init_machines.sh my-template.yml 10 bench-launch- test-k8s-namespace"
fi

template_yml=${1}
instances=${2}
echo "[INFO] Preparing to create ${instances} using the description found in ${template_yml}"


template_instance_name_prefix="bench-launch-"
if [ "$#" -eq 3 ]; then
    template_instance_name_prefix=${3}
fi
echo "[INFO] Using prefix '${template_instance_name_prefix}' when launching the bench"

namespace="default"
if [ "$#" -eq 4 ]; then
    namespace=${4}
fi
echo "[INFO] Using the '${namespace}' namespace"

d=$(<${template_yml})
for i in $(seq 1 $instances); do 
    di=${d//${NAME_PATTERN}/"${template_instance_name_prefix}${i}"}
    echo "${di}" | kubectl apply -n ${namespace} -f -
done