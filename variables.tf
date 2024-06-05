variable "sg_rules" {
  type = list(object({
    port     = number
    protocol = string
    cidr     = list(string)
  }))
  default = [
    {
      port     = 80
      protocol = "tcp"
      cidr     = ["0.0.0.0/0"]
    },
    {
      port     = 22
      protocol = "tcp"
      cidr     = ["0.0.0.0/0"]
    },
    {
      port     = 403
      protocol = "tcp"
      cidr     = ["0.0.0.0/0"]
    }
  ]
}

variable "instance_type" {
  default = "t2.micro"
}

variable "instance_ami" {
  default = "ami-074254c177d57d640"
}

variable "instance_name" {
  default = "Forge-Instance"
}