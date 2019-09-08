#!/usr/bin/env bash
set -e


if ! [ -x "$(command -v python3)" ]; then
  echo 'Error: python3 is not installed.'
  exit 1
fi

if ! [ -x "$(command -v awk)" ]; then
  echo 'Error: awk is not installed.'
  exit 1
fi

if ! [ -x "$(command -v jq)" ]; then
  echo 'Error: jq is not installed.'
  exit 1
fi

if ! [ -x "$(command -v terraform)" ]; then
  echo 'Error: terraform not available!.'
  exit 1
fi

if ! [ -x "$(command -v ansible-playbook)" ]; then
  echo 'Error: ansible-playbook not available!.'
  exit 1
fi

if ! [ -x "$(command -v ssh-keygen)" ]; then
  echo 'Error: ssh-keygen not available!.'
  exit 1
fi

if ! [ -x "$(command -v aws)" ]; then
  echo 'Error: aws not available!.'
  exit 1
fi

pushd () {
    command pushd "$@" > /dev/null
}

# shellcheck disable=SC2120
popd () {
    command popd "$@" > /dev/null
}

getAbsFilename() {
  # $1 : relative filename
  echo "$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
}

if [[ -z "$AWS_ACCESS_KEY_ID" && ! -f "$HOME/.aws/credentials" ]]
then
    aws configure
fi

#To DO uncomment
#read -p "Enter Stage Name (dev or test): " STAGE

export STAGE=dev
pushd terraform

[ -z $STAGE ] && { echo "STAGE parameter is empty. Exiting..." ; exit 1; }
[ ! -d vars/$STAGE ] && { echo "No directory found for specified stage: $STAGE" ; exit 1; }


BACKEND_VARS_PATH="$(pwd)/vars/$STAGE/backend.tfbackend"
INFRA_VARS_PATH="$(pwd)/vars/$STAGE/infra.tfvars"

S3_BUCKET="$(sed -n 's/^bucket\s*=\s*"\(.*\)"$/\1/p' < $BACKEND_VARS_PATH)"

if [[ -z "${S3_BUCKET}" ]]; then
  echo "please define backend bucket in $BACKEND_VARS_PATH"
  exit 1
fi


if  aws s3api head-bucket --bucket $S3_BUCKET 2>&1 ; then
    echo "bucket already exist and accessible"
else
    echo "bucket does not exit or permission is not there to view it, creating bucket"
    pushd backend
    terraform init && terraform apply -auto-approve -input=false -refresh=true -var-file=$BACKEND_VARS_PATH || true
    popd
fi

terraform init -input=false -backend=true -backend-config=$BACKEND_VARS_PATH
[ $? -ne 0 ] && { echo "Execution failed! Exiting..."; exit 1; }

terraform apply -auto-approve -input=false -refresh=true -var-file=$INFRA_VARS_PATH
[ $? -ne 0 ] && { echo "Execution failed! Exiting..."; exit 1; }

popd

pushd ansible

echo "Executing ansible-playbook"
echo "********************************************************************************************"
ansible-playbook -i host_inventory_services play.yml --extra-vars "@extra-vars.json"
[ $? -ne 0 ] && { echo "Execution failed! Exiting..."; exit 1; }
