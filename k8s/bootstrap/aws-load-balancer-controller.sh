helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set image.repository=602401143452.dkr.ecr.ap-southeast-1.amazonaws.com/amazon/aws-load-balancer-controller \
  --set clusterName=dev-bireal \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller