
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
    name  = "mi_apache"
    image = docker_image.mi_imagen.latest 
    
    
    # En ansible lo hariamos con el module: shell
    # delegate_to: localhost
    provisioner "local-exec" {
    # Este se ejecuta cuando creamos el objeto o se modifica
        command = "./crear_inventario.sh"
        #
        environment = {
            IP_MAQUINA = docker_container.mi_contenedor.ip_address
            DIRECTORIO = "/home/ubuntu/environment"
        }
    }
    provisioner "local-exec" {
    # Este se ejecuta cuando borramos el objeto
        command = "rm inventario.ini"
        working_dir = "/home/ubuntu/environment"
        when    = destroy
    }
}

resource "docker_image" "mi_imagen" {
    name = "httpd:alpine3.16"
}
