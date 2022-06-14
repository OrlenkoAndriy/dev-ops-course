terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.16.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_image" "wp-app" {
  name = "orlenkoandirj/wp-app:last"
}

resource "docker_image" "wp-mysql" {
  name = "mysql:8"
}

resource "docker_network" "wp-net" {
  name = "wp-net"
}

resource "docker_container" "wp-app" {
  image = docker_image.wp-app.latest
  name  = "app"

  ports {
    internal = 80
    external = 8888
  }

  networks_advanced {
    name = docker_network.wp-net.name
  }

  depends_on = [docker_network.wp-net, docker_container.wp-mysql]
}

resource "docker_volume" "wp-mysql-volume" {
  name = "wp-mysql-volume"
}

resource "docker_container" "wp-mysql" {
  image      = docker_image.wp-mysql.latest
  name       = "wp-mysql"

  networks_advanced {
    name = docker_network.wp-net.name
  }

  env = ["MYSQL_ROOT_PASSWORD=pass1234", "MYSQL_DATABASE=wordpress", "MYSQL_USER=wordpress", "MYSQL_PASSWORD=wordpress"]

  volumes {
    container_path = "/var/lib/mysql"
    volume_name = docker_volume.wp-mysql-volume.name
  }

  depends_on = [docker_network.wp-net, docker_volume.wp-mysql-volume]
}

