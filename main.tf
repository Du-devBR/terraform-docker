terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region                      = "us-east-1"
  skip_credentials_validation = true # Ignora validação de credenciais
  skip_requesting_account_id  = true # Ignora solicitação do ID da conta AWS
  skip_metadata_api_check     = true # Ignora verificação de metadados da AWS
  s3_use_path_style           = true # Necessário para compatibilidade com LocalStack

  # Define os endpoints do LocalStack para cada serviço AWS
  endpoints {
    ec2 = "http://localhost:4566"
  }
}

# Criar Security Group
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
  description = "Permitir tráfego HTTP e SSH"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Permitir SSH de qualquer lugar
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Permitir HTTP de qualquer lugar
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Permitir todo o tráfego de saída
  }
}

# Criar instância EC2 (simulada)
resource "aws_instance" "ec2_instance" {
  ami             = "ami-0c55b159cbfafe1f0" # AMI fictícia (LocalStack não valida)
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.ec2_sg.name] # Associar o Security Group
}
