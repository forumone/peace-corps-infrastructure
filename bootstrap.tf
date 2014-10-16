variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "key_path" {}
variable "key_name" {}
variable "aws_region" {
    default = "us-east-1"
}

# Ubuntu Trusty 14.04 LTS (x64)
variable "aws_amis" {
    default = {
        us-east-1 = "ami-9eaa1cf6"
        us-west-1 = "ami-076e6542"
        us-west-2 = "ami-3d50120d"
        us-gov-west-1 = "ami-3d57301e"
    }
}

# Specify the provider and access details
provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.aws_region}"
}

### VPC Configuration
resource "aws_vpc" "peace-corps" {
    cidr_block = "10.19.61.0/24"
    tags {
        Name = "peacecorps"
    }
}

resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.peace-corps.id}"
}

resource "aws_instance" "us-east-1a-nat" {
  ami = "ami-4c9e4b24"
  availability_zone = "us-east-1a"
  instance_type = "t2.micro"
  key_name = "peacecorps"
  security_groups = ["${aws_security_group.nat.id}", "${aws_security_group.herron-access.id}"]
  subnet_id = "${aws_subnet.us-east-1a-public.id}"
  associate_public_ip_address = false
  source_dest_check = false
  tags {
        Name = "NAT 1A"
        Agency = "Peace Corps"
  }
}

resource "aws_instance" "us-east-1b-nat" {
  ami = "ami-4c9e4b24"
  availability_zone = "us-east-1b"
  instance_type = "t2.micro"
  key_name = "peacecorps"
  security_groups = ["${aws_security_group.nat.id}", "${aws_security_group.herron-access.id}"]
  subnet_id = "${aws_subnet.us-east-1b-public.id}"
  associate_public_ip_address = false
  source_dest_check = false
  tags {
    Name = "NAT 1B"
    Agency = "Peace Corps"
  }
}

resource "aws_eip" "us-east-1a-nat" {
    instance = "${aws_instance.us-east-1a-nat.id}"
    vpc = true
}

resource "aws_eip" "us-east-1b-nat" {
    instance = "${aws_instance.us-east-1b-nat.id}"
    vpc = true
}

#### Configuration Management
# Create a CM Machine
resource "aws_instance" "config1a" {
  ami = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type = "t2.micro"
  key_name = "peacecorps"
  security_groups = ["${aws_security_group.private.id}"]
  subnet_id = "${aws_subnet.us-east-1a-private.id}"
  associate_public_ip_address = false
  tags {
        Name = "Config 1A"
        Agency = "Peace Corps"
  }
}

#### Configuration Management
# Create a CM Machine
resource "aws_instance" "configminion" {
  ami = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type = "t2.micro"
  key_name = "peacecorps"
  security_groups = ["${aws_security_group.private.id}"]
  subnet_id = "${aws_subnet.us-east-1a-private.id}"
  associate_public_ip_address = false
  tags {
        Name = "Config Minion"
        Agency = "Peace Corps"
  }
}

#### DEV SETUP
# Create a Dev Machine
resource "aws_instance" "dev" {
  ami = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type = "t2.micro"
  key_name = "peacecorps"
  security_groups = ["${aws_security_group.app.id}"]
  subnet_id = "${aws_subnet.us-east-1a-private.id}"
  associate_public_ip_address = false
  tags {
        Name = "Dev Box"
        Agency = "Peace Corps"
  }
}

# Create a new load balancer
resource "aws_elb" "dev" {
  name = "peacecorps-dev-elb"
  subnets = ["${aws_subnet.us-east-1a-public.id}", "${aws_subnet.us-east-1b-public.id}"]

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  listener {
    instance_port = 49521
    instance_protocol = "tcp"
    lb_port = 49521
    lb_protocol = "tcp"
  }

  instances = ["${aws_instance.dev.id}"]
}