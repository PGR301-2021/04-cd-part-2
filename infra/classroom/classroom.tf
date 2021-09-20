module "students" {
  source          = "../seat"
  ami             = "ami-08a3bbf30d1f2dac7"
  for_each        = var.students
  student_id      = each.key
}
