#!/bin/bash 

SVC_NAME=$(kubectl get svc -n confluent | grep controlcenter-bootstrap-lb)
IFS=' '

# Read the split words into an array
# based on space delimiter
read -ra svc_details <<< "$SVC_NAME"

echo ${svc_details[3]}