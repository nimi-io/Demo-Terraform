resource "docker_image" "prometheus" {
  name         = "prom/prometheus:v2.52.0"
  keep_locally = false
}

resource "docker_volume" "prometheus_data" {
  name = "prometheus-data"
}

resource "docker_container" "prometheus" {
  name  = "prometheus"
  image = docker_image.prometheus.image_id

  ports {
    internal = 9090
    external = 9090 # Access at http://localhost:9090
  }

  volumes {
    volume_name    = docker_volume.prometheus_data.name
    container_path = "/prometheus"
  }

  networks_advanced {
    name = docker_network.proxy.name
  }

  labels {
    label = "traefik.enable"
    value = "true"
  }

  labels {
    label = "traefik.http.routers.prometheus.rule"
    value = "Host(`prometheus.localhost`)"
  }

  labels {
    label = "traefik.http.services.prometheus.loadbalancer.server.port"
    value = "9090"
  }

  restart = "unless-stopped"
}
