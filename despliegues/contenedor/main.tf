terraform {
    required_providers {
        docker = {
            source = "kreuzwerker/docker"
        }
    }
}

provider "docker" {
}
# PASO 1 Crear clave ssh
# Paso 2 Crear una maquina en AWS donde ejecutar este conteendor
# PAso 3 Descargar imagen
resource "docker_image" "mi_imagen" {
    name = "${var.image.repo}:${var.image.tag}"
}
