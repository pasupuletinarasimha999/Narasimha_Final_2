resource "helm_release" "datadog" {
  name             = "datadog"
  repository       = "https://helm.datadoghq.com"
  chart            = "datadog"
  create_namespace = true
  namespace        = "datadog"
  values           = [file("values/datadog.yaml")]

  # Replace with your desired version (optional)
  # version = "9.3.0"

  # Override default chart values (optional)
  depends_on = [null_resource.datadog_secret]
}
resource "null_resource" "datadog_secret" {
  provisioner "local-exec" {
    command = "kubectl create secret generic datadog-secret --from-literal api-key='9f7050de2d2e171c5af701d065f6d9e7' -n datadog"
  }
  depends_on = [null_resource.datadog_namespace]
}
resource "null_resource" "datadog_namespace" {
  provisioner "local-exec" {
    command = "kubectl create namespace datadog"
  }
  depends_on = [null_resource.node_activation]
}