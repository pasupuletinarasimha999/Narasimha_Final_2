resource "helm_release" "nginx_ingress" {
  name             = "nginx-ingress-controller"
  repository       = "https://kubernetes.github.io/ingress-nginx/"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true
  set {
    name  = "controller.ingressClass"
    value = "nginx"
  }

  depends_on = [null_resource.node_activation]
}