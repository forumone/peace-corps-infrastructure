resource "aws_security_group" "gsa" {
    name = "gsa"
    description = "Allows access from GSA"
    vpc_id = "vpc-51971234"

    # access from GSA
    ingress {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        cidr_blocks = ["159.142.0.0/16"]
    }
}

resource "aws_security_group" "private" {
    name = "private"
    description = "Allows All Access from the private subnet"
    vpc_id = "vpc-51971234"
    ingress {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        cidr_blocks = ["10.19.61.0/0"]
    }
}

resource "aws_security_group" "logging" {
    name = "logging"
    description = "Allows Logging Access"
    vpc_id = "vpc-51971234"
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["10.19.61.0/0"]
    }
    ingress {
        from_port = 9200
        to_port = 9400
        protocol = "tcp"
        self = true
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
    cidr_blocks = ["159.142.0.0/16"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["159.142.0.0/16"]
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
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["159.142.0.0/16"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["159.142.0.0/16"]
  }
}

resource "aws_security_group" "paygov" {
  name = "peace-corps-paygov"
  description = "Allow services for Pay.gov"
  vpc_id = "vpc-51971234"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["199.169.197.157/32", "199.169.192.157/32", "199.169.194.157/32"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["199.169.197.157/32", "199.169.192.157/32", "199.169.194.157/32"]
  }
}