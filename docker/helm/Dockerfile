FROM alpine:3

RUN apk add python3 py3-pip curl openssl bash pwgen git && \
    pip3 install pyaml && \
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
    chmod 700 get_helm.sh && \
    ./get_helm.sh && \ 
    curl -L https://github.com/roboll/helmfile/releases/download/v0.138.6/helmfile_linux_amd64 > helmfile && \
    rm get_helm.sh && \
    mv helmfile /usr/bin/ && \
    chmod 755 /usr/bin/helmfile && \
    helm plugin install https://github.com/databus23/helm-diff && \
    helm repo add jetstack https://charts.jetstack.io/ && \
    helm repo add nginx-ingress https://kubernetes.github.io/ingress-nginx && \
    helm repo add bitnami https://charts.bitnami.com/bitnami && \
    helm repo add fluent https://fluent.github.io/helm-charts && \
    helm repo update
 
