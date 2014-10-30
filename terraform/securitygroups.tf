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

resource "aws_security_group" "admin" {
  name = "peace-corps-admin"
  description = "Allow access to the admin webservers"
  vpc_id = "vpc-51971234"
  
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
}

resource "aws_security_group" "rds" {
    name = "peace-corps-rds"
    description = "Peace Corps RDS default security group"
    vpc_id = "vpc-51971234"

    ingress {
        cidr_blocks = ["10.19.61.0/24"]
        from_port = 5432
        to_port = 5432
        protocol = "tcp"
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