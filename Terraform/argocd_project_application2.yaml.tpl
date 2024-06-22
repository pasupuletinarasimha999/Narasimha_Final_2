apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: elk
  namespace: argocd
  # Finalizer that ensures that project is not deleted until it is not referenced by any application
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  project: elk
  source:
    repoURL: 'https://github.com/pasupuletinarasimha999/Narasimha_Final_2.git'
    path: Kubernetes/Code/ELK
    targetRevision: HEAD
  destination:
    server: ${server}
    namespace: elk
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