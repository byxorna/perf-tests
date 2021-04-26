#!/usr/bin/env bash
set -e

test_dir="./testing"
TEST="${TEST:-controlplane-load-1}"
NODES="${NODES:-10}"
CL2_NAMESPACES="${CL2_NAMESPACES:-1}"
CL2_NODEGROUPS="${CL2_NODEGROUPS:-1}"
CONTEXT="${CONTEXT:-$(kubectl config current-context)}"
CLUSTER_NAMESPACE="${CLUSTER_NAMESPACE:-${CONTEXT%%.*}-k8s}"

if [[ ! -d $test_dir/$TEST ]] ; then
  echo "" >&2
  ls $test_dir
  exit 1
fi

if [[ -z $CLUSTER_NAMESPACE ]] ; then
  echo "Must set CLUSTER_NAMESPACE (i.e. CLUSTER_NAMESPACE=chillpenguin-k8s)" >&2
  exit 1
fi

echo -n "Run TEST=${TEST} against CONTEXT=${CONTEXT}? (yes/no) " >&2
read input
if [[ $input != yes ]] ; then
  echo "aborting" >&2
  exit 3
fi

set -ex
CL2_CLUSTER_NAMESPACE="${CLUSTER_NAMESPACE}" \
  CL2_CLUSTER_FQDN="${CONTEXT}" \
  CL2_NODEGROUPS="${CL2_NODEGROUPS}" \
  CL2_NAMESPACES=${CL2_NAMESPACES} \
    ./run-e2e.sh --provider=local --nodes=${NODES} --testconfig=${test_dir}/${TEST}/config.yaml
