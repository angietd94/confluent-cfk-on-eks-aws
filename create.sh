#!/bin/bash

git clone https://github.com/mbhanpura/SBC-Demo.git
cd SBC-Demo

brew install terraform
brew install helm
brew install watch

cd terraform/
terraform init
terraform apply -var="region=eu-west-2" -var="name=eks-angelica-terraform" -var="instance_type=t2.large"
#Configure kubectl to Connect to Your EKS Cluster
aws eks --region eu-west-2 update-kubeconfig --name eks-angelica-terraform-eks
aws eks update-kubeconfig --name eks-angelica-terraform-eks --region eu-west-2

cd ..
cd kubernetes/
#export TUTORIAL_HOME="https://raw.githubusercontent.com/confluentinc/confluent-kubernetes-examples/tree/master/quickstart-deploy/kraft-quickstart"
kubectl create namespace confluent
kubectl config set-context --current --namespace confluent

helm repo add confluentinc https://packages.confluent.io/helm
helm repo update
helm upgrade --install confluent-operator confluentinc/confluent-for-kubernetes --namespace confluent
helm pull confluentinc/confluent-for-kubernetes --untar --untardir=cfk-kubernetes-operator --namespace confluent

#kubectl apply -f confluent-platform.yaml -n confluent
kubectl apply -f cp-setup.yaml -n confluent



watch kubectl get pods --namespace confluent

kubectl get pods
####Once all the pods are in the RUNNING state, run the following command to get the required url to access Control Center.

chmod +x get-url.sh
./get-url.sh



kubectl delete namespace confluent