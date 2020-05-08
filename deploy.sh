#!/usr/bin/env bash
set -exo pipefail

export LC_ALL=C.UTF-8
export LANG=C.UTF-8

clusterName="glb-tes"
clusterRegion="us-central1-c"
projectName="api-ingka-qa"

logintocluster(){
#gcloud container clusters get-credentials $clusterName --zone $clusterRegion --project $projectName
echo "already run the gcloud as gcloud resetapi is slow in this computer"
}

################----------------------------------Installation of Helm chart--------------------################################
#verify the helm 3 installed or not

helm_version(){
#echo "Start the installation and configuration of kong"
# Check for helm3
if helm version | grep -q "version.BuildInfo{Version:\"v3."; then
    echo "Helm version 3 found, continuing...."
else
    echo "This script is designed to work with Helm version 3 only! Please install version 3 as your default version of Helm and try again"
    echo "https://helm.sh/docs/intro/install/" && exit 1
fi
}

##verify the namespace for kong####
namespace_val(){
if kubectl get ns | grep k2 ; then
   echo "Namespace is exists continue..."
else
   echo "Create the namespce"
      if kubectl create ns k2; then
        echo "Namespace kong is created"
      else "Unable to create ns pls check your credentials and kubectl value"
          exit 1
          fi
fi
}

# Check repo exists and if not then add it and update the helm repository
addupdaterepo(){
if helm repo list | grep -q "https://kubernetes-charts.storage.googleapis.com/"; then
    echo "Helm stable repo exists, continuing..."
else
    if helm repo add stable https://kubernetes-charts.storage.googleapis.com/; then
        echo "Helm Stable repo added successfully"
    else
        echo "Unable to add the Helm Stable repo, exiting..."
                exit 1
    fi
fi
# Run repo update
helm repo update
}

# Deploy kong
deploy_template(){
echo "check the chart is already installed or not , if present then upgrade otherwise install the chart"

if helm ls -n k2 | grep kong; then
   echo "Kong is alreday install upgrade the k§ong configuration"
   helm upgrade kong kong/kong -f values.yml --set ingressController.installCRDs=false --wait -n k2
else
   echo "Install the kong"
   helm install kong kong/kong -f values.yml --set ingressController.installCRDs=false --wait -n k2
   exit 1
fi

}
#echo "#############################################################################################"
#echo "                        KONG is now deployed."
#echo "       To connect to Kong, please execute the following commands:              "
#echo "HOST=$(kubectl get svc --namespace default kong-kong-proxy -o jsonpath='{.status.loadBalancer.ingress[0].ip}')"
#echo "PORT=$(kubectl get svc --namespace default kong-kong-proxy -o jsonpath='{.spec.ports[0].port}')"
#echo "                           export PROXY_IP=${HOST}:${PORT}           "
#echo "                                curl $PROXY_IP                       "
#echo "#############################################################################################"
deploy() {
logintocluster
if [ $? -gt 0 ]
 then
  error "could not login gcloud"
  return 1
fi
helm_version
namespace_val
addupdaterepo
deploy_template
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  deploy
  if [ $? -eq 0 ]
  then
    echo "done with kong deployment"
  fi
fi
