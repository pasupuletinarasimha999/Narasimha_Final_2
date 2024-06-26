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

# Resource for ArgoCD Ingress with proper API version and Kind


resource "kubectl_manifest" "argocd_ingress" {
  provider = kubectl.cluster1
  yaml_body = <<YAML
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: argocd-ingress-rules
  namespace: argocd
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: "/"
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
    kubernetes.io/ingress.class: "nginx"
spec:
  ingressClassName: nginx
  rules:
    - host: argocd.krazyworks.shop
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: argocd-server
                port:
                  number: 80
  tls:
    - hosts:
        - argocd.krazyworks.shop
      secretName: argocd-letsencrypt-certificate
YAML

  depends_on = [helm_release.argocd]
}
# Resource for ArgoCD Project with proper API version and Kind
resource "kubectl_manifest" "argocdproject" {
  provider = kubectl.cluster1
  yaml_body = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: my-app-project
  namespace: argocd
  # Finalizer that ensures that project is not deleted until it is not referenced by any application
  finalizers:
    - resources-finalizer.argocd.argoproj.io/background
spec:
  # Project description
  description: Learning CICD
  # Allow manifests to deploy from any Git repos
  sourceRepos:
    - '*'
  destinations:
    - namespace: my-app
      server: https://kubernetes.default.svc
    - namespace: argocd
      server: https://kubernetes.default.svc
    - namespace: monitoring
      server: https://kubernetes.default.svc
  # Deny all cluster-scoped resources from being created, except for Namespace
  clusterResourceWhitelist:
    - group: "*"
      kind: "*"
  # Orphaned resources is a feature that allows you to automatically delete Kubernetes resources that are no longer managed by any application in the ArgoCD cluster.
  orphanedResources:
    warn: false
YAML
  depends_on = [kubectl_manifest.argocd_ingress] # Updated dependency
}

resource "kubernetes_secret" "github_credentials" {
  provider = kubernetes.eks_demo
  metadata {
    name      = "github-credentials"
    namespace = "argocd"
  }

  data = {
    username = var.github_username
    password = var.github_token
  }
  depends_on = [helm_release.argocd]
}
resource "kubectl_manifest" "argocd_repository" {
provider = kubectl.cluster1
  yaml_body = <<YAML
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-cm
  namespace: argocd
data:
  repositories: |
    - url: https://github.com/pasupuletinarasimha999/Narasimha_Final_2.git
      usernameSecret:
        name: github-credentials
        key: username
      passwordSecret:
        name: github-credentials
        key: password
YAML

  depends_on = [kubernetes_secret.github_credentials]
}
/*
resource "kubectl_manifest" "argocd_application" {
provider = kubectl.cluster1
  yaml_body = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: main-application
  namespace: argocd
  # Finalizer that ensures that project is not deleted until it is not referenced by any application
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  project: my-app-project
  source:
    repoURL: 'https://github.com/pasupuletinarasimha999/Narasimha_Final_2.git'
    path: Kubernetes/Code/Manifests
    targetRevision: HEAD
  destination:
    server: 'https://kubernetes.default.svc'
    namespace: my-app
  syncPolicy:
    managedNamespaceMetadata:
      labels:
        argocd.argoproj.io/managed-by: argo
    automated:
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
      - PruneLast=true
      - Validate=false

YAML

  depends_on = [kubectl_manifest.argocd_repository]
}*/

locals {
  project_yaml = templatefile("${path.module}/argocd_project.yaml.tpl", {
    server = data.external.k8s_server.result.server
  })
}
/*
resource "kubectl_manifest" "argocdproject2" {
  provider = kubectl.cluster2
  yaml_body = local.project_yaml
  depends_on = [kubernetes_manifest.argocd_ingress]
}
locals {
  deployment_yaml = templatefile("${path.module}/argocd_project_application2.yaml.tpl", {
    server = data.external.k8s_server.result.server
  })
}
resource "kubectl_manifest" "argocdapplication2" {
  provider = kubectl.cluster2
  yaml_body = local.deployment_yaml
}*/
data "external" "k8s_server" {
  program = ["bash", "${path.module}/get_k8s_server.sh"]
}