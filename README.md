# workshop-calicocloud-aks-security-observability

This content was built for free training workshops. 

If you're looking for general docs for Calico, we recommend you start [here](https://docs.tigera.io/)

## Prerequisites

Ensure the make, jq, helm, and azure cli are installed and you have an Azure account with appropriate permissions.

## Setup

First configure the repo’s config.mk to set the default Azure region.

```
$ cat config.mk
-include local-config.mk

LOCATION ?= eastus
```

Configure the local-config.mk settings.

```
$ cat local-config.mk
SUBSCRIPTION=<azure subscrition>
RESOURCE_GROUP_NAME=calicoCloudDemo
NAME=calicoCloudDemo
SSH_PUBKEY="ssh-rsa YOUR SSH PUBLIC KEY user@emailaddress.com"
```

Deploy the Cluster

```
$ make

Usage:
  make <target>

Manage Azure Resource Manager deployments.
  test             Validate the template.
  deploy           Deploy the template.
  cleanup          Cleanup the deployment leaving resource group intact.
  teardown         Teardown the deployment by removing the resource group.
  list             List the deployments.
  login            Login to Azure
  setup            Create the resource group and setup rbac.
  kubeconfig       Configure kubeconfig for AKS

Help
  help             Type make followed by target you wish to run.
```

1. make login
2. make setup
3. make test
4. make deploy
5. make kubeconfig
6. kubectl get nodes

```
kubectl get nodes
NAME                                STATUS   ROLES   AGE     VERSION
aks-agentpool-38582030-vmss000000   Ready    agent   6m22s   v1.21.2
aks-agentpool-38582030-vmss000001   Ready    agent   6m23s   v1.21.2
```

## Login to Calico Cloud and connect cluster with AKS curl bash script.

Sign up for Calico Cloud https://www.calicocloud.io/home and join your AKS cluster.

```
curl <your script url > | bash
kubectl get tigerastatus
```

## Deploy demo apps

```
kubectl apply -f demo/apps/shell
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install wordpress -f demo/apps/wordpress/values.yaml bitnami/wordpress -n wordpress --create-namespace
kubectl get pods -n wordpress -w
```

## Configure AKS cluster Calico settings

Apply FelixConfiguration to setup logging settings

```
kubectl apply -f demo/felix-config
```

## Compliance and reporting

Apply Calico Cloud compliance reports to generate reports every 10 minutes

```
kubectl apply -f demo/compliance-reports
```

Live demo

## Pod-based workload access controls

Setup our demo workload access control scenario to secure the demo apps

```
kubectl apply -R -f demo/tiers/
kubectl apply -R -f demo/network-policy
```

Get your public ip address

```
curl http://ifconfig.co
```

Live demo

## DNS Policies

Live demo

## Dynamic Service Graph and Dynamic Packet Capture

Live demo
