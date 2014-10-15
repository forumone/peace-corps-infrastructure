variable "herron_cidr" {}

resource "aws_security_group" "gsa-access" {
    name = "gsa-access"
    description = "Allows SSH/HTTPS access from GSA"
    vpc_id = "vpc-51971234"

    # SSH access from GSA
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["159.142.0.0/16"]
    }

    # HTTPS access from GSA
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["159.142.0.0/16"]
    }
}

resource "aws_security_group" "herron-access" {
    name = "herron-access"
    description = "Allows SSH/HTTPS access from Sean Herron"
    vpc_id = "vpc-51971234"

    # SSH access from Sean
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.herron_cidr}"]
    }

    # HTTPS access from Sean
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["${var.herron_cidr}"]
    }
}

resource "aws_security_group" "private" {
    name = "private"
    description = "Allows All Access"
    vpc_id = "vpc-51971234"
    ingress {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 0
        to_port = 65535
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "nat" {
  name = "peace-corps-nat"
  description = "Allow services from the private subnet through NAT"
  vpc_id = "vpc-51971234"
  
  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app" {
  name = "peace-corps-app"
  description = "Allow services for Application Servers"
  vpc_id = "vpc-51971234"
  
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 49521
    to_port = 49521
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}