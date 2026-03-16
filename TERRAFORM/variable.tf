# variable "ec2_instance_type"  {
#   description = "Type of EC2 instance"
#   default     = "t3.micro"
#   type = string
# }

variable "ec2_instance_ami_id"  {
  description = "AMI ID for EC2 instance"
  default     = "ami-019715e0d74f695be" # Ubuntu
  type = string
  
}

variable "ec2_root_storage_size"  {
  description = "Root storage size for EC2 instance"
  default     = 15
  type = number

}