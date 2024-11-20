

resource "aws_key_pair" "terraformkey" {
    key_name   = "terraform-key"
    public_key = file("/Users/bhaktathapa/Desktop/TerraformProject/terraform_key.pub")
  
}
terraform {
  backend "s3" {

        bucket = "new-one-for-terraform-demo"
        key = "demoterr/terraform.tfstate"
        region = "us-west-1"
        encrypt = true
        dynamodb_table = "terraform-statefile-table"
  }

}


resource "aws_instance" "my_instance" {

    key_name = aws_key_pair.terraformkey.key_name
    security_groups = [aws_security_group.my_SG.name]
    user_data = file ("/Users/bhaktathapa/Desktop/TerraformProject/install.sh")
    
    ami   = "ami-0da424eb883458071"
    instance_type = "t2.micro"
    tags = {
        Name = "terraform_instance"
    }


}

resource "aws_default_vpc" "default" {
 
}

resource "aws_security_group" "my_SG" {

    name = "mySG"
    vpc_id = aws_default_vpc.default.id

    ingress {

        description = "allow SSH port "
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }
    ingress {

        description = "allow SSH port "
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }

    egress {

        description = "outgoing traffic"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]


    }
  
}
