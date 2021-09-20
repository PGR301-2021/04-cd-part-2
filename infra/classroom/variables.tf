variable "students" {
  type = map

   default = {
    kaam004 = {
      email = "kaam004@feide.egms.no"
    }

  }
}

variable "region" {
  type = string
  default = "eu-north-1"
}