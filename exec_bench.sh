#!/bin/bash

if [ "$#" -lt 3 ]; then
    echo "[INFO] Specify the script to be executed, number of instances, and the log folder, followed by the optional template instance name prefix and namespace"
    echo "[INFO] e.g: init_machines.sh bench.sh /tmp/kubebench/ bench-launch- test-k8s-namespace"
    exit 1
fi

script=${1}
instances=${2}
log_path="${3}/$(date +%Y%m%d_%H%M%S)"
template_instance_name_prefix="bench-launch-"
namespace="default"
if [ -f "/var/run/secrets/kubernetes.io/serviceaccount/namespace" ]; then
    namespace=$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace)
fi
if [ "$#" -ge 4 ]; then
    template_instance_name_prefix=${4}
    if [ "$#" -eq 5 ]; then
        namespace=${5}
    fi
fi

mkdir -p ${log_path}
echo "[INFO] Running the script '${script}' in ${instances} intances in the '${namespace}' namespace using prefix '${template_instance_name_prefix}' with logs stored at '${log_path}'"


echo "[INFO] copying the script on every instance"
d=$(base64 < ${script})
for i in $(seq 1 $instances); do 
    kubectl exec -n ${namespace}  deploy/"${template_instance_name_prefix}${i}" -- bash -c "echo -n \"${d}\" | base64 -d > ~/script.sh && chmod +x ~/script.sh"
done

echo "[INFO] Running the script on every instance"
trap 'pkill -P $$' SIGHUP SIGINT SIGTERM
for i in $(seq 1 $instances); do 
    intance_name="${template_instance_name_prefix}${i}"
    echo "Running on instance ${intance_name}"
    kubectl exec -n ${namespace}  deploy/"${intance_name}" -- bash -c "~/script.sh" 2>&1 > ${log_path}/${intance_name}.log &
done
echo "[INFO] Waiting for all jobs to finish"
wait