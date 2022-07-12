#!/bin/bash
set -e
source ../scripts/bash/functions.sh

ENV=$1
CMD=${2:-apply}
env_validate "$ENV"

# build up some useful helmfile flags
DEBUG_FLAG=""
RELEASES_FLAG=""
SKIPDEPS_FLAG=""
EXTRA_FLAGS=""
POST_CMD_FLAGS=""

# if the 2nd arg starts with a dash, it means the helm command is skipped and a flag
# e.g. `--release=*` is used in its place. We also default the helm cmd to `apply` in this case
[[ $CMD == -* ]] && CMD="apply"

PROVIDER=$(../scripts/python/env_var.py $ENV "provider")

# Create single yaml env file
CONFIG_FILE=$(env_path $ENV ".env.yaml")
python3 ../scripts/python/env_all_yaml.py $ENV

shift ; # env
shift ; # operation

while test ${#} -gt 0
do
  VAR=$1
    case $VAR in
        --debug      ) DEBUG_FLAG="--debug" ;;
        --release=*  ) RELEASES_FLAG="$RELEASES_FLAG --selector name=`echo $VAR | cut -d "=" -f2`" ;;
        --skip-deps* ) SKIPDEPS_FLAG="--skip-deps" ;;
        --skip-diff-on-install ) POST_CMD_FLAGS="$POST_CMD_FLAGS --skip-diff-on-install" ;;
        -f           ) EXTRA_FLAGS="$EXTRA_FLAGS $1 $2"; shift ; ;;
        --file       ) EXTRA_FLAGS="$EXTRA_FLAGS $1 $2"; shift ; ;;
        *) echo "WARN: Skipping unknown argument: $1" ;;
    esac
    shift ;
done

# Vault secrets in Helmfile - see here for usage:
# https://github.com/variantdev/vals#suported-backends
# export VAULT_ADDR=https://vault.devops.klpsre.com
# echo "Authenticating to Vault..."
# vault token lookup >> /dev/null || vault login -path=azure -method=oidc

# Helm
echo -e "\nRunning Helm"
[[ ! -z "$RELEASES_FLAG" ]] && echo "helmfile selector(s): $RELEASES_FLAG"
[[ ! -z "$SKIPDEPS_FLAG" ]] && echo "helmfile skipping dependencies (--skip-deps): yes"
[[ ! -z "$DEBUG_FLAG" ]] && echo "helmfile debug mode (--debug): yes"
pushd helm
ALL_HELMFILE_ARGS="$EXTRA_FLAGS $DEBUG_FLAG -e $ENV $RELEASES_FLAG $CMD $SKIPDEPS_FLAG $POST_CMD_FLAGS"
echo "EXEC: \"helmfile $ALL_HELMFILE_ARGS\""
helmfile $ALL_HELMFILE_ARGS
popd

rm $CONFIG_FILE  || true
