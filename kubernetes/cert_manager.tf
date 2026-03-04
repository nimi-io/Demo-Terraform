# cert-manager — automatic TLS certificate management
resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  namespace  = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.15.0"

  create_namespace = true

  set {
    name  = "crds.enabled"
    value = "true"
  }

  timeout = 600

  depends_on = [kind_cluster.local]
}

# Wait for cert-manager CRDs and webhook to be fully ready before creating issuers
resource "time_sleep" "wait_for_cert_manager" {
  create_duration = "30s"
  depends_on      = [helm_release.cert_manager]
}

# Self-signed ClusterIssuer — applied via kubectl after CRDs are registered
resource "null_resource" "selfsigned_issuer" {
  triggers = {
    cert_manager_version = helm_release.cert_manager.version
  }

  provisioner "local-exec" {
    command = <<-EOT
      kubectl apply -f - --kubeconfig=${path.module}/local-cluster-config <<EOF
      apiVersion: cert-manager.io/v1
      kind: ClusterIssuer
      metadata:
        name: selfsigned
      spec:
        selfSigned: {}
      EOF
    EOT
  }

  depends_on = [time_sleep.wait_for_cert_manager]
}
