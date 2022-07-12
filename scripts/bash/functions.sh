ENUM_TERRAFORM_VAR_FILE="tfvars.json"
ENUM_SHARED_VAR_FILE="config.json"
ENUM_NAMESPACE_VAR="k8s_namespace"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

function env_validate {
    ENV=$1
    if [ -z $ENV ]
    then
        echo "Please ensure you provide an ENV variable"
        exit 1
    fi
    env_validate_file "$ENV" "$ENUM_TERRAFORM_VAR_FILE"
    env_validate_file "$ENV" "$ENUM_SHARED_VAR_FILE"
}


function env_validate_file {
    ENV="$1"
    FILE="$2"
    JSON="$(env_path "$ENV" "$FILE")"
    if [ ! -f "$JSON"  ]
    then
        echo "Please ensure your env ($ENV) contains the file: $FILE"
        exit 1
    fi
} 


function env_path {
    ENV="$1"
    FILE="$2"
    echo "$DIR/../../env/$1/$2"
}

function config_path {
    env_path $1 $ENUM_SHARED_VAR_FILE
}

function tfvars_path {
    env_path $1 $ENUM_TERRAFORM_VAR_FILE
}


function echo_line {
    echo "------------------------------------------------------------------------"
}


function echo_heading () {
    echo -e "\n$1"
    echo "------------------------------------------------------------"
}


function create_namespace_if_not_exists() {
    if ! kubectl get namespaces -o json | jq -r ".items[].metadata.name" | grep $1
    then
        kubectl create namespace $1
    fi
}

function label_namespace_for_redis() {
    if [[ "$(kubectl get ns $1 -o json | jq '.metadata | .labels | ."redis-namespace"' -r)" != "true" ]]
    then
        kubectl label namespace $1 redis-namespace="true"
    fi
}

pushd () {
    command pushd "$@" > /dev/null
}

popd () {
    command popd "$@" > /dev/null
}
