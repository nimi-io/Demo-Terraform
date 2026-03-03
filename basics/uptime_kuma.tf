resource "docker_image" "uptime_kuma" {
  name         = "louislam/uptime-kuma:1"
  keep_locally = false
}

resource "docker_volume" "uptime_kuma_data" {
  name = "uptime-kuma-data"
}

resource "docker_container" "uptime_kuma" {
  name  = "uptime-kuma"
  image = docker_image.uptime_kuma.image_id

  ports {
    internal = 3001
    external = 3001 # Access at http://localhost:3001
  }

  volumes {
    volume_name    = docker_volume.uptime_kuma_data.name
    container_path = "/app/data"
  }

  networks_advanced {
    name = docker_network.proxy.name
  }

  labels {
    label = "traefik.enable"
    value = "true"
  }

  labels {
    label = "traefik.http.routers.uptime-kuma.rule"
    value = "Host(`uptime.localhost`)"
  }

  labels {
    label = "traefik.http.services.uptime-kuma.loadbalancer.server.port"
    value = "3001"
  }

  restart = "unless-stopped"
}
