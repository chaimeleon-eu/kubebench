
label_value="chaimeleon.eu/kubebench=true"
if [ "$#" -ge 1 ]; then
    label_value=${1}
fi
echo "[INFO] Removing all k8s objects with label ${label_value}"

echo -e "\n[INFO] Deleting  common resource kinds"
kubectl delete all -l ${label_value}
echo -e "\n[INFO] Deleting secrets"
kubectl delete secrets -l ${label_value}
echo -e "\n[INFO] Deleting configmaps"
kubectl delete configmaps -l ${label_value}