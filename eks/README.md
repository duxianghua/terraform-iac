## Install EKS cluster
```sh
terraform plan
terraform apply
```

## 销毁集群
```sh
terraform destroy
```

## 获取kubeconfig
```sh
aws eks update-kubeconfig --name eks-demo-01
```

