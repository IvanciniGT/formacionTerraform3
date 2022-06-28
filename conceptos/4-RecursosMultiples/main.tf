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
    count = var.numero_de_instancias 
    # Esto es un bucle muy simple
    # Pero también nos permite montar un IF, condicional
    # tenemos una variable disponible cuando usamos un count
    #.    Es la variable count.index
    name  = "mi_apache_${count.index}"
    image = docker_image.mi_imagen.latest
    
    ports {
        internal = 80
        external = 8080 + count.index
    }
}

resource "docker_container" "mi_contenedor2" {
    for_each = var.contenedores_a_crear # Le meto un mapa 
    # Esto es un bucle muy simple
    # Pero también nos permite montar un IF, condicional
    # tenemos una variable disponible cuando usamos un count
    #.    Es la variable count.index
    name  = each.key
    image = docker_image.mi_imagen.latest
    
    ports {
        internal = 80
        external = each.value
    }
}

resource "docker_image" "mi_imagen" {
    name = "httpd:alpine3.16"
}
