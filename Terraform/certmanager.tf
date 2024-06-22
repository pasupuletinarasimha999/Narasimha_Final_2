resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  create_namespace = true
  namespace        = "kube-system"
  set {
    name  = "installCRDs"
    value = "true"
  }
  set {
    name  = "wait-for"
    value = module.cert_manager_irsa_role.iam_role_arn
  }
  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com\\/role-arn"
    value = module.cert_manager_irsa_role.iam_role_arn
  }
  values = [
    "${file("values/values-cert-manager.yaml")}"
  ]
  depends_on = [module.cert_manager_irsa_role]
}

module "cert_manager_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.2.0" # Latest as of July 2022

  role_name                     = "cert-manager"
  attach_cert_manager_policy    = true
  cert_manager_hosted_zone_arns = ["arn:aws:route53:::hostedzone/Z094518528U0CKC6X69LA"] # Lab HostedZone

  oidc_providers = {
    eks = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:cert-manager"]
    }
  }
  depends_on = [null_resource.node_activation]
}

resource "kubernetes_manifest" "certissuer" {
  provider = kubernetes.eks_demo
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = "letsencrypt-prod"
    }
    spec = {
      acme = {
        server                  = "https://acme-v02.api.letsencrypt.org/directory"
        email                   = "pasupuletinarasimha256@gmail.com"
        privateKeySecretRef = {
          name = "account-key-prod"
        }
        solvers = [
          {
            http01 = {
              ingress = {
                class = "nginx"
              }
            }
          },
          {
            dns01 = {
              route53 = {
                hostedZoneID = "Z094518528U0CKC6X69LA"
                region       = "us-east-1"
                selector = {
                  dnsZones = [
                    "krazyworks.shop"
                  ]
                }
              }
            }
          }
        ]
      }
    }
  }
  depends_on = [helm_release.cert_manager]
}