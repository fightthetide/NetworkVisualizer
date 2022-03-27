variable "elastic_app" {
  type = string
  default = "network-visualizer"
}

variable "app_env" {
  type = string
  default = "fightthetide"
}

variable "solution_stack_name" {
  type = string
  default = "infra-stack"
}

variable "tier" {
  type = string
  default = "dev"
}

variable "instance_type" {
  type = string
  default = "t3.micro"
}
 
variable "vpc_id" {}