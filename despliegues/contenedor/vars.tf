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
    type        = set(string)  # Esta variable alberga un texto
    description = "Variables de entorno del contenedor"
    nullable    = true
}

variable "image" {
    type        = object({
        repo = string
        tag  = string
    })
    description = "Imagen de contenedor a descargar. Debe contener las claves 'repo' y 'tag'"
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



