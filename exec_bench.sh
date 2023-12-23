#!/bin/bash

if [ "$#" -lt 2 ]; then
    echo "[INFO] You have to specify the the file with the scripts and the number of instances, followed by the optional template instance name prefix and namespace"
    echo "[INFO] e.g: init_machines.sh my-template.yml 10 bench-launch- test-k8s-namespace"
fi

script=${1}
instances=${2}
echo "[INFO] Running the script at ${script} in ${instances} intances"

template_instance_name_prefix="bench-launch-"
if [ "$#" -eq 3 ]; then
    template_instance_name_prefix=${3}
fi
echo "[INFO] Using prefix '${template_instance_name_prefix}' when running the scripts"

namespace="default"
if [ "$#" -eq 4 ]; then
    namespace=${4}
fi
echo "[INFO] Using the '${namespace}' namespace"


echo "[INFO] copying the script"

d=$(<${script})
for i in $(seq 1 $instances); do 
    kubectl exec -d -n ${namespace}  deploy/"${template_instance_name_prefix}${i}" -- bash -c "echo \"${d}\" > ~/script.sh && chmod +x ~/script.sh"
done

echo "[INFO] Running the script on every instance"
for i in $(seq 1 $instances); do 
    kubectl exec -d -n ${namespace}  deploy/"${template_instance_name_prefix}${i}" -- bash -c "echo \"${d}\" > ~/script.sh && chmod +x ~/script.sh"
done