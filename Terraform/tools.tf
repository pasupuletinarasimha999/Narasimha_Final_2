
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


resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.12.3"
  namespace  = "cert-manager"
  depends_on = [
    null_resource.cert_manager    
  ]
}
# create namespace for cert mananger
resource "null_resource" "cert_manager" {
  provisioner "local-exec" {
    command = "kubectl create namespace cert-manager"
  }
}