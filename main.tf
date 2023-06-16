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
}

# Execute command to copy nginx.conf file inside the container
resource "null_resource" "copy_nginx_conf" {
  triggers = {
    container_id = docker_container.nginx.id
  }

  provisioner "local-exec" {
    command = <<EOF
sleep 5
docker cp nginx.conf ${docker_container.nginx.id}:/etc/nginx/nginx.conf
EOF
  }
}

# Output the NGINX container IP address
output "nginx_container_ip" {
  value = docker_container.nginx.ports.0.external
}
