resource "null_resource" "node_activation" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --region ${var.region-name} --name ${var.cluster_name}"
  }
}






/*resource "null_resource" "certinstallationnamespace" {
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
}*/
