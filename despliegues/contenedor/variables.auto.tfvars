container_name = "minginx"

image = {
    repo = null
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
    
environment = null