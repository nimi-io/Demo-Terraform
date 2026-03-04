# cert-manager — automatic TLS via Let's Encrypt on AWS
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

  depends_on = [module.eks]
}

# Wait for cert-manager webhook to become ready
resource "time_sleep" "wait_for_cert_manager" {
  create_duration = "30s"
  depends_on      = [helm_release.cert_manager]
}

# Let's Encrypt production issuer (real trusted certificates)
# Requires your domain's DNS to point to the Traefik NLB
resource "null_resource" "letsencrypt_issuer" {
  triggers = {
    cert_manager_version = helm_release.cert_manager.version
  }

  provisioner "local-exec" {
    command = <<-EOT
      kubectl apply -f - <<EOF
      apiVersion: cert-manager.io/v1
      kind: ClusterIssuer
      metadata:
        name: letsencrypt
      spec:
        acme:
          server: https://acme-v02.api.letsencrypt.org/directory
          email: ${var.acme_email}
          privateKeySecretRef:
            name: letsencrypt-account-key
          solvers:
            - http01:
                ingress:
                  class: traefik
      EOF
    EOT
    environment = {
      KUBECONFIG = "${path.module}/kubeconfig"
    }
  }

  depends_on = [time_sleep.wait_for_cert_manager]
}
