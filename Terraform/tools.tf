
resource "null_resource" "node_activation" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --region us-east-1 --name ${var.cluster-name}"
  }
  depends_on = [aws_eks_node_group.private-nodes]
}

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  values           = [file("values/argocd.yaml")]
  depends_on = [null_resource.node_activation]
}

resource "null_resource" "ingressnamespace" {
  provisioner "local-exec" {
    command = "kubectl create namespace nginx-ingress"
  }
  depends_on = [null_resource.node_activation]
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

  depends_on = [aws_eks_node_group.private-nodes,null_resource.ingressnamespace]
}
resource "null_resource" "certmanagernamespace" {
  provisioner "local-exec" {
    command = "kubectl create namespace cert-manager"
  }
  depends_on = [null_resource.node_activation]
}

resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = "cert-manager"
  set {
    name  = "installCRDs"
    value = "true"
  }
  depends_on = [
    null_resource.certmanagernamespace    
  ]
}
resource "null_resource" "certinstallationnamespace" {
  provisioner "local-exec" {
    command = "kubectl create namespace my-app"
  }
  depends_on = [null_resource.node_activation]
}
resource "helm_release" "certinstallation" {
  name       = "letsencrypt-cert-issuer"            # Name for your deployment
  repository = "https://pasupuletinarasimha999.github.io/helmcharts/letsencryptcerts/"  # Helm chart repository URL
  chart      = "letsencryptcerts"  
  namespace = "my-app"
  depends_on = [helm_release.cert_manager]
}
