curl -sL --http1.1 https://cnfl.io/cli | sh -s -- latest && alias confluent="$PWD/bin/confluent"
confluent version
confluent login --organization-id 6567aa66-3926-4012-8364-9051f660cef8



echo "Which is the cluster you want to use?"
read cluster_name

cluster_name="cluster_confluent_for_k8s_demo"
ENV="env-rrr650"

confluent environment use $ENV 


CC_ENV=$(confluent environment list -o json | jq -r ".[] | select(.name | contains(\"$cluster_name\")) | .id") && echo "Your Confluent Cloud environment: $CC_ENV" && confluent environment use $CC_ENV


ataccadughetti+ubb@confluent.io
SabaTbilisi?1996  


CCLOUD_CLUSTER_ID=$(confluent kafka cluster list -o json \
                  | jq -r '.[] | select(.name | contains(\"$cluster_name\")) | .id') \
&& echo "Your Confluent Cloud cluster ID: $CCLOUD_CLUSTER_ID" \
&& confluent kafka cluster use $CCLOUD_CLUSTER_ID
Get the bootstrap endpoint for the Confluent Cloud cluster.

CC_BOOTSTRAP_ENDPOINT=$(confluent kafka cluster describe -o json | jq -r .endpoint) \
&& echo "Your Cluster's endpoint: $CC_BOOTSTRAP_ENDPOINT"
Create a Confluent Cloud service account for CP Demo and get its ID.

confluent iam service-account create cp-demo-sa --description "service account for $cluster_name" \
&& SERVICE_ACCOUNT_ID=$(confluent iam service-account list -o json \
                     | jq -r '.[] | select(.name | contains("cp-demo")) | .id') \
&& echo "Your cp-demo service account ID: $SERVICE_ACCOUNT_ID"
Enable Schema Registry in your Confluent Cloud environment, if you have not already done so.

confluent schema-registry cluster enable --cloud <cloud> --geo <geo>
Get the ID and endpoint URL for your Schema Registry cluster.

CC_SR_CLUSTER_ID=$(confluent schema-registry cluster describe -o json | jq -r .cluster_id) \
&& CC_SR_ENDPOINT=$(confluent schema-registry cluster describe -o json | jq -r .endpoint_url) \
&& echo "Schema Registry Cluster ID: $CC_SR_CLUSTER_ID" \
&& echo "Schema Registry Endpoint: $CC_SR_ENDPOINT"
Create a Schema Registry API key for the $cluster_name service account.

confluent api-key create \
   --service-account $SERVICE_ACCOUNT_ID \
   --resource $CC_SR_CLUSTER_ID \
   --description "SR key for cp-demo schema link"
