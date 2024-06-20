resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  values           = [file("values/argocd.yaml")]
  depends_on       = [null_resource.node_activation]

}

resource "null_resource" "argocd_admin_passwd" {
  provisioner "local-exec" {
    command = "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"
  }
  depends_on = [helm_release.argocd]
}

output "argocd_admin_password" {
  value = null_resource.argocd_admin_passwd
}


/*
resource "kubernetes_ingress" "argocd_ingress" {
  metadata {
    name      = "argocd-ingress-rules"
    namespace = "argocd"
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
      "cert-manager.io/cluster-issuer"             = "letsencrypt-prod"
      "kubernetes.io/ingress.class"                = "nginx"
    }
  }

  spec {
    ingress_class_name = "nginx"

    rule {
      host = "argocd.krazyworks.shop"

      http {
        path {
          path      = "/"

          backend {
            service_name = "argocd-server"
            service_port = 80
          }
            }
          }
        }
      }

    

    tls {
      hosts       = ["argocd.krazyworks.shop"]
      secret_name = "argocd-letsencrypt-certificate"
    }
  
  depends_on = [helm_release.argocd]
}*/