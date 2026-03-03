resource "docker_image" "traefik" {
  name         = "traefik:v3.1"
  keep_locally = false
}

resource "docker_container" "traefik" {
  name  = "traefik"
  image = docker_image.traefik.image_id

  command = [
    "--api.insecure=true",
    "--providers.docker=true",
    "--providers.docker.exposedbydefault=false",
    "--entrypoints.web.address=:80",
  ]

  ports {
    internal = 80
    external = 80
  }

  ports {
    internal = 8080
    external = 8080 # Traefik dashboard
  }

  volumes {
    host_path      = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
    read_only      = true
  }

  networks_advanced {
    name = docker_network.proxy.name
  }

  restart = "unless-stopped"
}
