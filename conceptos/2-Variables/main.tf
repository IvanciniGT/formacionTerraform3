terraform {
    required_providers {
        docker = {
            source = "kreuzwerker/docker"
        }
    }
}

provider "docker" {
}

resource "docker_container" "mi_contenedor" {
    #name  = "${var.nombre_contenedor}"
    name  = var.nombre_contenedor
    image = docker_image.mi_imagen.latest 
    env = var.variables_contenedor
    
    ports {
        internal = 80
        external = 83
        ip       = "172.31.10.35"
        protocol = "tcp"
    }
}
    

resource "docker_image" "mi_imagen" {
    #name = var.imagen                              # OPCION 1
    name = "${var.programa}:${var.version_programa}"               # OPCION 2
            # Interpolación de textos   
}
