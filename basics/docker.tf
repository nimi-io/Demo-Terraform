resource "docker_image" "vault" {
  name         = "hashicorp/vault:1.17.1"
  keep_locally = false
}

resource "docker_container" "vault" {
  name  = "terraform-basics-vault"
  image = docker_image.vault.image_id

  ports {
    internal = 8200
    external = 8200
  }
}
