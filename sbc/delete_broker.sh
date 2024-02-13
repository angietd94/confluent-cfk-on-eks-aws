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

echo "---------------------------------POD Status---------------------------------"
kubectl get pods -n $namespace
POD_NAME=$(kubectl get pods --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}' -n $namespace | grep ^kafka-1)
echo "-----------------------------------------------------------------------------"
echo "Deleting $POD_NAME ..."
echo "-----------------------------------------------------------------------------"
kubectl delete pod $POD_NAME -n $namespace
echo "-----------------------------------------------------------------------------"
echo "Deletion finished"
sleep 5
echo "---------------------------------POD Status----------------------------------"
kubectl get pods -n $namespace