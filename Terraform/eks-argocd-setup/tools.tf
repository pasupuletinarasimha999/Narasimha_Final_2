
resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  values           = [file("values/argocd.yaml")]
  depends_on = [aws_eks_node_group.private-nodes]
}

resource "null_resource" "create_nginx_ingress_namespace" {
  provisioner "local-exec" {
    command = "kubectl create namespace nginx-ingress"
  }
}
resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress-controller"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"
  namespace = "nginx-ingress"

  set {
    name  = "controller.ingressClass"
    value = "nginx"
  }

  depends_on = [aws_eks_node_group.private-nodes,
  null_resource.create_nginx_ingress_namespace]
}
