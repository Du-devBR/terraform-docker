terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

# Criar a VPC principal
resource "docker_network" "vpc_network" {
  name   = "vpc_network"
  driver = "bridge"
}

# Criar sub-rede pública
resource "docker_network" "subnet_public" {
  name   = "subnet_public"
  driver = "bridge"
}

# Criar sub-rede privada
resource "docker_network" "subnet_private" {
  name   = "subnet_private"
  driver = "bridge"
}

# Criar sub-rede de dados
resource "docker_network" "subnet_data" {
  name   = "subnet_data"
  driver = "bridge"
}

# Criar um container na subrede pública (Nginx)
resource "docker_container" "nginx_public" {
  name  = "nginx_public"
  image = "nginx"

  networks_advanced {
    name = docker_network.subnet_public.name
  }
  ports {
    internal = 80
    external = 80
  }
}

# Criar um container backend na subrede privada
resource "docker_container" "backend_private" {
  name    = "backend_private"
  image   = "alpine"
  command = ["sleep", "3600"]

  networks_advanced {
    name = docker_network.subnet_private.name
  }
}

# Criar um container MySQL na subrede de dados
resource "docker_container" "db_data" {
  name  = "db_data"
  image = "mysql"
  env   = ["MYSQL_ROOT_PASSWORD=root"]

  networks_advanced {
    name = docker_network.subnet_data.name
  }
}

# Criar um roteador que conecta todas as redes para permitir comunicação controlada
resource "docker_container" "router" {
  name    = "router"
  image   = "alpine"
  command = ["sh", "-c", "apk add iptables && sleep 3600"]

  networks_advanced {
    name = docker_network.subnet_public.name
  }

  networks_advanced {
    name = docker_network.subnet_private.name
  }

  networks_advanced {
    name = docker_network.subnet_data.name
  }

  capabilities {
    add = ["NET_ADMIN"]
  }
}
resource "null_resource" "configure_router" {
  depends_on = [docker_container.router]

  provisioner "local-exec" {
    command = <<EOT
      sleep 5
      docker exec router sh -c 'iptables -A FORWARD -s 192.168.192.0/20 -d 192.169.192.0/20 -j ACCEPT;
      iptables -A FORWARD -s 192.168.160.0/20 -d 192.168.162.0/20 -j DROP;'
EOT
  }
}
