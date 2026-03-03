resource "docker_image" "grafana" {
  name         = "grafana/grafana:11.0.0"
  keep_locally = false
}

resource "docker_volume" "grafana_data" {
  name = "grafana-data"
}

resource "docker_container" "grafana" {
  name  = "grafana"
  image = docker_image.grafana.image_id

  ports {
    internal = 3000
    external = 3000 # Access at http://localhost:3000 (admin / admin)
  }

  volumes {
    volume_name    = docker_volume.grafana_data.name
    container_path = "/var/lib/grafana"
  }

  networks_advanced {
    name = docker_network.proxy.name
  }

  # Pre-configure Prometheus as a datasource
  env = [
    "GF_SECURITY_ADMIN_USER=admin",
    "GF_SECURITY_ADMIN_PASSWORD=admin",
    "GF_USERS_ALLOW_SIGN_UP=false",
    "GF_DATASOURCES_DEFAULT_NAME=Prometheus",
    "GF_DATASOURCES_DEFAULT_TYPE=prometheus",
    "GF_DATASOURCES_DEFAULT_URL=http://prometheus:9090",
    "GF_DATASOURCES_DEFAULT_ACCESS=proxy",
    "GF_DATASOURCES_DEFAULT_IS_DEFAULT=true",
  ]

  labels {
    label = "traefik.enable"
    value = "true"
  }

  labels {
    label = "traefik.http.routers.grafana.rule"
    value = "Host(`grafana.localhost`)"
  }

  labels {
    label = "traefik.http.services.grafana.loadbalancer.server.port"
    value = "3000"
  }

  restart = "unless-stopped"
}
