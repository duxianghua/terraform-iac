# EKS最佳实践
## 1. What is Amazon EKS? [link](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html)
Amazon Elastic Kubernetes Service (Amazon EKS) 是一项托管服务，通俗的说就是由aws帮我们托管维护一组k8s控制平面(Kubernetes control plane)
* Control Plane Components
  * kube-apiserver
  * etcd
  * kube-scheduler
  * kube-controller-manager

* 特性功能
  * 跨多个可用区构建k8s control plance
  * 根据负载自动扩展control plance instance, 检查并替换不健康的control plance instance, 并提供自动的版本更新功能
  * 与AWS服务集成
    * Amazon ECR
    * Elastic Load Balancing
    * IAM
    * Amazon VPC

## Amazon EKS 控制平面架构

Amazon EKS 为每个集群运行单个租户 Kubernetes 控制平面。控制平面基础设施不在集群或 AWS 账户之间共享。控制平面由至少两个 API 服务器实例和三个etcd跨 AWS 区域内三个可用区运行的实例组成。亚马逊 EKS：

* 主动监控控制平面实例上的负载并自动扩展它们以确保高性能。
* 自动检测并替换不健康的控制平面实例，根据需要跨 AWS 区域内的可用区重新启动它们。
* 利用 AWS 区域的架构来保持高可用性。因此，Amazon EKS 能够提供API 服务器终端节点可用性的 [SLA](http://aws.amazon.com/eks/sla).

[LINK](https://anywhere.eks.amazonaws.com/docs/concepts/eksafeatures/#comparing-amazon-eks-anywhere-to-amazon-eks)

|Feature|Desc|
|---|---|
|K8s control plane management|Managed by AWS|
|K8s control plane location	|AWS cloud|
|Cluster updates|Managed in-place updates for control plane and managed rolling updates for data plane.|

## Compute
|Feature|Desc|
|---|---|
|Compute options|Amazon EC2, AWS Fargate|
|Supported node operating systems|Amazon Linux 2, Windows Server, Bottlerocket, Ubuntu|
|Serverless|Amazon EKS on AWS Fargate|

## Management
|Feature|Desc|
|---|---|
|Command line interface (CLI)|eksctl|
|Console view for Kubernetes objects|Native EKS console connection|
|Infrastructure-as-code	|AWS CloudFormation, 3rd-party solutions|
|Logging and monitoring	|CloudWatch, CloudTrail, 3rd-party solutions|
|GitOps|Flux Controller|

## Functions and tooling
|Feature|Desc|
|---|---|
|Networking and Security|Amazon VPC CNI supported. Calico supported for network policy. Other compatible 3rd-party CNI plugins available.|
|Load balancer|Elastic Load Balancing including Application Load Balancer (ALB), and Network Load Balancer (NLB)|
|Service mesh|AWS App Mesh, community, or 3rd-party solutions|
|Community tools and Helm|Works with compatible community tooling and helm charts.|
|成本管理|kubecost|