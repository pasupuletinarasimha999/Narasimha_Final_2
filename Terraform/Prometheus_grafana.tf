resource "helm_release" "grafana" {
  name             = "grafana"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana"
  create_namespace = true
  namespace        = "monitoring"
  depends_on       = [null_resource.node_activation]
}
resource "helm_release" "prometheus" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  create_namespace = true
  namespace        = "monitoring"
  depends_on       = [null_resource.node_activation]
}
resource "null_resource" "grafana_admin_passwd" {
  provisioner "local-exec" {
    command = "kubectl -n monitoring get secret/grafana -o jsonpath='{.data.admin-password}' | base64 -d"
  }
  depends_on = [helm_release.grafana]
}
output "grafana_admin_password" {
  value = null_resource.grafana_admin_passwd
}