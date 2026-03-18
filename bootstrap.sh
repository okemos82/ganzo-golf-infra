#!/bin/bash
# ============================================================
# bootstrap.sh — Run ONCE to set up Terraform remote state
#                and create the Azure Service Principal.
#
# Prerequisites: az CLI installed and logged in
#   az login
# ============================================================
set -e

SUBSCRIPTION_ID="e44f9b78-12ae-4908-b217-4e32b069d1ac"
LOCATION="eastus"
TF_STATE_RG="ganzo-golf-tfstate-rg"
TF_STATE_SA="ganzogolftfstate"   # globally unique, lowercase, 3-24 chars
TF_STATE_CONTAINER="tfstate"

echo "==> Setting subscription..."
az account set --subscription "$SUBSCRIPTION_ID"

echo "==> Creating resource group for Terraform state..."
az group create \
  --name "$TF_STATE_RG" \
  --location "$LOCATION"

echo "==> Creating storage account for Terraform state..."
az storage account create \
  --name "$TF_STATE_SA" \
  --resource-group "$TF_STATE_RG" \
  --location "$LOCATION" \
  --sku Standard_LRS \
  --encryption-services blob

echo "==> Creating blob container..."
az storage container create \
  --name "$TF_STATE_CONTAINER" \
  --account-name "$TF_STATE_SA"

echo ""
echo "==> Creating Service Principal (Contributor on subscription)..."
echo "    Copy the JSON output below — you will need it for GitHub Secrets."
echo ""

az ad sp create-for-rbac \
  --name "ganzo-golf-sp" \
  --role Contributor \
  --scopes "/subscriptions/$SUBSCRIPTION_ID" \
  --sdk-auth

echo ""
echo "==> Done! Next steps:"
echo "    1. Copy the JSON above and add these GitHub Secrets to ganzo-golf-infra repo:"
echo "       ARM_CLIENT_ID       → clientId"
echo "       ARM_CLIENT_SECRET   → clientSecret"
echo "       ARM_SUBSCRIPTION_ID → subscriptionId"
echo "       ARM_TENANT_ID       → tenantId"
echo "    2. Also add:"
echo "       TF_VAR_DB_ADMIN_PASSWORD  → your chosen DB password"
echo "       TF_VAR_OPENAI_API_KEY     → your OpenAI key"
echo "    3. In GitHub → Settings → Environments → create 'production'"
echo "       and add yourself as a required reviewer."
