resource "docker_image" "argocd" {
  name         = "quay.io/argoproj/argocd:v2.11.0"
  keep_locally = false
}

resource "docker_container" "argocd" {
  name  = "argocd"
  image = docker_image.argocd.image_id

  command = ["argocd-server", "--insecure"]

  ports {
    internal = 8080
    external = 8081 # Access at http://localhost:8081 (admin / run: argocd admin initial-password)
  }

  networks_advanced {
    name = docker_network.proxy.name
  }

  labels {
    label = "traefik.enable"
    value = "true"
  }

  labels {
    label = "traefik.http.routers.argocd.rule"
    value = "Host(`argocd.localhost`)"
  }

  labels {
    label = "traefik.http.services.argocd.loadbalancer.server.port"
    value = "8080"
  }

  restart = "unless-stopped"
}
