# Declare the provider (Docker)
terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

provider "docker" {}

# Define the NGINX Docker container
resource "docker_container" "nginx" {
  name  = "nginx_container"
  image = "nginx:latest"
  ports {
    internal = 80
    external = 8081
  }
  restart = "always"

  # Mount volume for SSL certificates
  volumes {
    container_path = "/etc/nginx/certs"
    host_path      = "/path/to/ssl/certs"
  }

  # Copy nginx.conf file to the container
  provisioner "dockerfile" {
    content = file("nginx.conf")
    destination = "/etc/nginx/nginx.conf"
  }
}
