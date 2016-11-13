#!/bin/bash

set -e
set -o pipefail

REQUIRED_ENV='AWS_SECRET_ACCESS_KEY AWS_ACCESS_KEY_ID TF_VAR_db_password TF_VAR_sshpubkey_file'
VALID_DEPLOYMENT_ENVS="development production"
ORCHESTRATION_REPO="https://github.com/yasn77/pressr-orchestration.git"
TMP_CLONE_DIR=$(mktemp -d)

usage() {
  cat <<EOF

The following environment variables need to be set:
$(echo "$REQUIRED_ENV" | tr ' ' '\n' | xargs -I {} echo -e \\t{})

Valid environments:
$(echo "$VALID_DEPLOYMENT_ENVS" | tr ' ' '\n' | xargs -I {} echo -e \\t{})

Usage: $(basename $0) <environment> <tag>

EOF
}

pre_flight_check() {
  we_have_a_problem=0

  [[ $# -ne 2 ]] && we_have_a_problem=1
  $(echo $VALID_DEPLOYMENT_ENVS | grep -q "$1") || we_have_a_problem=1

  for e in $REQUIRED_ENV
  do
    if [ -z "$(env | grep $e | cut -d'=' -f 2)" ]
    then
      echo "$e is not set"
      we_have_a_problem=1
    fi
  done

  if [[ $we_have_a_problem -eq 1 ]]
  then
    usage
    exit 1
  fi
}

tag_repo() {
  git fetch
  git tag $1
  git push origin $1
}

run_deploy() {
  DEPLOY_ENV=$1
  TAG=$2
  git clone $ORCHESTRATION_REPO $TMP_CLONE_DIR
  cd $TMP_CLONE_DIR/ansible
  pip install -r ../requirements.txt 1>/dev/null &&
  ansible-playbook --private-key $TF_VAR_sshpubkey_file  -i hosts/ec2.py -u ubuntu -e pressr_git_ref=${TAG} -e deployment_environment=${DEPLOY_ENV} pressr_deploy.yml
  cd - 1>/dev/null
  rm -rf $TMP_CLONE_DIR
}

pre_flight_check $*
tag_repo $2
run_deploy $*
