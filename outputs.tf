# Exibir o ID da rede VPC
output "vpc_network_id" {
  description = "ID da rede VPC"
  value       = docker_network.vpc_network.id
}

# Exibir o ID da sub-rede pública
output "subnet_public_id" {
  description = "ID da sub-rede pública"
  value       = docker_network.subnet_public.id
}

# Exibir o ID da sub-rede privada
output "subnet_private_id" {
  description = "ID da sub-rede privada"
  value       = docker_network.subnet_private.id
}

# Exibir o ID da sub-rede de dados
output "subnet_data_id" {
  description = "ID da sub-rede de dados"
  value       = docker_network.subnet_data.id
}

# Exibir o nome do container Nginx na rede pública
output "nginx_public_name" {
  description = "Nome do container Nginx na sub-rede pública"
  value       = docker_container.nginx_public.name
}

# Exibir o nome do container backend na rede privada
output "backend_private_name" {
  description = "Nome do container backend na sub-rede privada"
  value       = docker_container.backend_private.name
}

# Exibir o nome do container MySQL na sub-rede de dados
output "db_data_name" {
  description = "Nome do container MySQL na sub-rede de dados"
  value       = docker_container.db_data.name
}

# Exibir o nome do roteador
output "router_name" {
  description = "Nome do roteador que conecta as redes"
  value       = docker_container.router.name
}

# Não podemos acessar diretamente o Gateway, por isso, remova os outputs relacionados a ele
output "subnet_public_ip" {
  description = "IP da sub-rede pública"
  value       = "Configure o IP manualmente se necessário."
}

output "subnet_private_ip" {
  description = "IP da sub-rede privada"
  value       = "Configure o IP manualmente se necessário."
}

output "subnet_data_ip" {
  description = "IP da sub-rede de dados"
  value       = "Configure o IP manualmente se necessário."
}

# Exibir as variáveis de ambiente do container MySQL
output "db_data_env" {
  description = "Variáveis de ambiente do container MySQL"
  value       = docker_container.db_data.env
}
