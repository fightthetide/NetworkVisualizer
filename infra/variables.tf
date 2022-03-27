variable "elastic_app" {
  type = string
  default = "network-visualizer"
}

variable "app_env" {
  type = string
  default = "develop"
}

variable "solution_stack_name_match" {
  type = string
  default = "^64bit Amazon Linux 2 v3(.*) running Python 3(.*)$"
}

variable "tier" {
  type = string
  default = "WebServer"
}

variable "instance_type" {
  type = string
  default = "t3.micro"
}

variable "region" {
  type = string
  default = "us-east-1"
}

variable "vpc_id" {
  type = string
}