terraform {
    required_providers {
        docker = {
            source = "kreuzwerker/docker"
        }
    }
}

provider "docker" {
}

module "nginx" {
    
    source = "../modulo_contenedor"
    
    container_name = var.contenedor
    image = var.image
    
    ports = [
        {
            internal = 80
            external = var.external_port
            protocol = "tcp"
            ip       = "0.0.0.0"
        }
    ]
        
}