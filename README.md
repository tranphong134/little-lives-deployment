# Deployment

## Pre-requisites

The following tools need to be installed on the machine performing the deployment:

-   [helm](https://helm.sh)
-   [helmfile](https://github.com/roboll/helmfile)
-   [helm-diff](https://github.com/databus23/helm-diff) - install with `helm plugin install https://github.com/databus23/helm-diff`
-   [aws-cli-v2](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
-   [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
-   [pwgen](https://formulae.brew.sh/formula/pwgen) - necessary for bootstrapping (cluster creation/initial)

It is assumed that you have the appropriate AWS (`~/.aws/credentials`) and Kubernetes (`~/.kube/config`)
configuration setup and your environment variables are setup such that the correct AWS account and correct
Kubernetes cluster are targetted.

You'll also need:

-   `pyyaml` - example installation on MacOS is `python3 -m pip install pyyaml` - adapt to your specific system accordingly
-   `jq` - example installation on MacOS is `brew install jq` - adapt to your specific system accordingly

## Installation

### Bootstrap

To bootstrap the application installation the following steps need to be performed. Once
the cluster is bootstrapped all management will be done via Helm.

#### Create namespace

```bash
$ kubectl create ns tranphong134-dev

namespace/tranphong134-dev created

#### Update CoreDNS configuration

CoreDNS is deployed as part of the Kubernetes managed infrastructure and not currently managed via Helm. To support directly addressable pods (needed for the SFUs) we need to modify CoreDNS's configmap:

```bash
$ kubectl apply -f bootstrap/coredns-configmap.yaml

configmap/coredns configured
```
### Install Application

> Remember to copy the environment kubeconfig to ~/.kube/config

**Recommend to install/deploy one service at a time (`diff` before `apply`)**

To view differences with deployed charts:

```bash
$ helmfile diff
```

To apply changes to cluster:

```bash
$ helmfile apply
```

### Using the helper script `helm.sh`

The `helm.sh` helper script eventually invokes `helmfile <cmd>` where `<cmd>` is one of the standard
helmfile commands, defaulting to `apply`. Before executing `helmfile`, the script does other routines
such as writing values from config json files into `.env.yaml` files. It can be used manually or as
part of an automated CI/CD process (e.g. invoked within a Concourse/Jenkins runner).

For more details, head straight to the [`k8s/helm.sh`](./k8s/helm.sh) file and inspect the script to see what it does.

Execution syntax:

```bash
./helm.sh <env> <cmd> [--release=<release-name>] [--skip-deps]
```

Note that the `--skip-deps` argument is not applicable to all helmfile commands (but only a selected few)

Example basic usage:

```bash
# run `helm diff` for the `vn-dev` env on *all* chart releases
./helm.sh vn-dev diff
```

Example advanced usage:

```bash
./helm.sh vn-dev diff --release=backend --skip-deps

# run `helm apply` for the `vn-dev` env on *only* the `backend` and `backend-2` releases
./helm.sh vn-dev apply --release=backend --release=backend-2
```
