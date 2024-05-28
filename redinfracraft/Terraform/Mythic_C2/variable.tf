variable "key_name" {

}


variable "security_group" {
  description = "Security group for EC2 Instance creatted through Terraform."
  default = "Mythic_EC2_sg"
}
