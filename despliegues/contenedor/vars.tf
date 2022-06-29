variable "container_name" {
    type        = string
    description = "Nombre del contenedor a crear en docker"
}

variable "ports" {
    type        = list(object({
        internal = number
        external = number
        protocol = string 
        ip       = string
    }))
    description = "Puertos a exponer en el host para el contenedor"
    validation  {
        condition = alltrue([ for puerto in var.ports: 
                                puerto.internal >=1 && puerto.internal <= 65535 ])
        error_message = "Los puertos del contenedor (internal) deben estar entre 1 y 65535"
    }
    validation  {
        condition = alltrue([ for puerto in var.ports: 
                                puerto.external >=1 && puerto.external <= 65535 ])
        error_message = "Los puertos del host (external) deben estar entre 1 y 65535"
    }
    validation  {
        #condition = alltrue([ for puerto in var.ports: 
        #                        puerto.protocol == "tcp" || puerto.protocol == "udp" ])
        condition = alltrue([ for puerto in var.ports: 
                                contains( ["tcp","udp"], puerto.protocol) ])
        error_message = "El protocolo debe ser tcp o udp"
    }
    validation  {
        condition = alltrue([ for puerto in var.ports: 
                                puerto.ip == null 
                                    || length(regexall("^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)[.]){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
                                            , puerto.ip != null ? 
                                                puerto.ip : 
                                                "IP INVALIDA" ))
                                        ==1 ]
                                )
        error_message = "La IP no tiene un formato válido"
    }
    nullable = true
}
#variable "ports" {
#    type        = list(map(string))
#    description = "Puertos a exponer en el host para el contenedor"
#    validation  {
#        condition = alltrue([ for puerto in var.ports: contains(keys(puerto),"internal") ])
#        error_message = "No se ha definido un puerto 'internal' para la variable ports"
#    }
#}

#PUERTO:
#{
#    internal = 80
#    external = 8080
#    protocol = "tcp"
#    ip       = "0.0.0.0"
#}
#--->
#keys(PUERTO)
#["internal", "external", "protocol", "ip"]
#contains ( keys(PUERTO) , "internal" ) -> true
#[true, true]

variable "environment" {
    type        = map(string)  # Esta variable alberga un texto
    description = "Variables de entorno del contenedor"
    nullable    = true
}

variable "image" {
    type        = object({
        repo = string
        tag  = string
    })
    description = "Imagen de contenedor a descargar. Debe contener las claves 'repo' y 'tag'"
    
    validation {
        condition = var.image.repo != null && var.image.tag != null
        error_message = "Debe suministrar un valor no nulo para el repo y el tag de la imagen"
    }
}

#variable "image" {
#    type        = map(string)
#    description = "Imagen de contenedor a descargar. Debe contener las claves 'repo' y 'tag'"
#    
#    validation {
#        condition = alltrue( [contains(keys(var.image),"repo") , 
#                              contains(keys(var.image),"tag") ])
#                   # Expresion lógica TRUE | FALSE
#                    # TRUE  > Se entiende que está bien
#                    # FALSE > Se entiende que el valor de la variable no es bueno
#                    #         Evita la ejecución del script
#        error_message = "La variable image debe contener un map con las claves: 'repo' y 'tag'"
#    }
#    validation {
#        condition = (
#                        contains(keys(var.image),"repo") 
#                     && contains(keys(var.image),"tag")
#                    )
#        error_message = "La variable image debe contener un map con las claves: 'repo' y 'tag'"
#    }
#
#    
#    validation {
#        condition = contains(keys(var.image),"repo") 
#        error_message = "La variable image debe contener un map con la clave: 'repo'"
#    }
#
#    validation {
#        condition =  contains(keys(var.image),"tag")
#        error_message = "La variable image debe contener un map con la clave: 'tag'"
#    }
#    
#}




variable "volumes" {
    type        = list(object({
        host_path       = string 
        container_path  = string
    }))
    description = "Volumenes locales a montar en el contenedor"
    validation  {
        condition = alltrue([ for volumen in var.volumes: 
            length(regexall("^[/]?([A-Za-z0-9_.-]+[/]?)*$"
                        , volumen.host_path != null ? 
                            volumen.host_path : 
                            "RUTA INVALIDA" ))
                    ==1 ]
                                )
        error_message = "La ruta del host para el volumen no es válida"
    }
    validation  {
        condition = alltrue([ for volumen in var.volumes: 
            length(regexall("^[/]?([A-Za-z0-9_.-]+[/]?)*$"
                        , volumen.container_path != null ? 
                            volumen.container_path : 
                            "RUTA INVALIDA" ))
                    ==1 ]
                                )
        error_message = "La ruta del contenedor para el volumen no es válida"
    }
    nullable = true
}


variable "resources" {
    type        = object({
        memory       = number # Es nullable y requerido sin opción a cambiarlo
        cpu_shares   = number
    })
    description = "Limitacion de recursos Hardware para el conteendor"
    
    validation {
        condition = var.resources.memory > 0
        error_message = "El valor de memoria del contenedor debe ser positivo"
    }
    validation {
        condition = var.resources.cpu_shares > 0
        error_message = "El valor de cpu_shares del contenedor debe ser positivo"
    }
    nullable = true
}