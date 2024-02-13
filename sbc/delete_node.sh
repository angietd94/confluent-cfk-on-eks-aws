#!/bin/bash
 
while getopts ":n:" option; do
  case $option in
    n)
      namespace="$OPTARG"
      ;;
    *)
      echo "Usage: $0 [-n namespace] "
      exit 1
      ;;
  esac
done


echo "------------------------------------NODE Status-------------------------------------"
kubectl get nodes -n confluent
NODE_NAME=$( kubectl get nodes --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}' -n confluent | grep ^ip | head -1 )
echo "----------------------------------------"
echo "Failing $NODE_NAME ..."
echo "----------------------------------------"
kubectl taint node $NODE_NAME -n confluent taint=confluent:NoExecute
echo "----------------------------------------------------------------------------"
echo "Node has Failed"
echo "---------------------------------------------------POD Status-----------------------------------------------------"
sleep 5
kubectl get pods -n confluent -o wide
echo "-----------------------------------------------------------------------------"
sleep 180
kubectl taint node $NODE_NAME -n confluent taint=confluent:NoExecute-
POD_NAME=$(kubectl get pods --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}' -n confluent | grep ^kafka-1)
echo "------------------------------------------------------------------------------"
kubectl delete pod $POD_NAME -n confluent
echo "---------------------------------------------------POD Status-----------------------------------------------------"
kubectl get pods -n confluent -o wide