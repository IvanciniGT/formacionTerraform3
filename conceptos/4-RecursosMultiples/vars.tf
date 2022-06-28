variable "numero_de_instancias" {
    type        = number
    description = "Numero de contenedores a generar"
    default     =  3
}

variable "contenedores_a_crear" {
    type        = map(number)
    description = "Numero de contenedores a generar"
    default     =  {
        contenedor1 = 8090
        contenedorB = 9097
    }
}
