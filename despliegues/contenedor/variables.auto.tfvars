container_name = "minginx"

image = {
    repo = "nginx"
    tag  = "latest"
}

ports = [
        {
            internal = 80
            external = 8080
            protocol = "tcp"
            ip       = "0.0.0.0"
        },
        {
            internal = 81
            external = 8081
            protocol = "tcp"
            ip       = null
        }
    ]
    
environment = {
    CLAVE1 = "valor1"
    CLAVE2 = "valor2"
}

volumes = [{
        host_path = "/tmp/otRa12Cosa.cosa"
        container_path = "/root/"
    }]
    
resources = null
        