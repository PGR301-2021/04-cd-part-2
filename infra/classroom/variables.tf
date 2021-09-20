variable "students" {
  type = map(any)

  default = {
    glennbech = {
      email      = "glenn.bech@gmail.com"
    }
  }
}