apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: elk
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
  - namespace: elk
    server: ${server}
  - namespace: argocd
    server: ${server}
  - namespace: monitoring
    server: ${server}
  # Deny all cluster-scoped resources from being created, except for Namespace
  clusterResourceWhitelist:
  - group: "*"
    kind: "*"

  #  is a feature that allows you to automatically delete Kubernetes resources that are no longer managed by any application in the ArgoCD cluster. 
  orphanedResources:
    warn: false