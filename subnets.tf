### Public Subnets
resource "aws_subnet" "us-east-1a-public" {
    vpc_id = "${aws_vpc.peace-corps.id}"
    cidr_block = "10.19.61.0/27"
    availability_zone = "us-east-1a"
}

resource "aws_subnet" "us-east-1b-public" {
    vpc_id = "${aws_vpc.peace-corps.id}"
    cidr_block = "10.19.61.32/27"
    availability_zone = "us-east-1b"
}

### Private Subnets
resource "aws_subnet" "us-east-1a-private" {
    vpc_id = "${aws_vpc.peace-corps.id}"
    cidr_block = "10.19.61.64/27"
    availability_zone = "us-east-1a"
}

resource "aws_subnet" "us-east-1b-private" {
    vpc_id = "${aws_vpc.peace-corps.id}"
    cidr_block = "10.19.61.96/27"
    availability_zone = "us-east-1b"
}

### Routing Tables (Private Subnets)
resource "aws_route_table" "us-east-1a-private" {
  vpc_id = "${aws_vpc.peace-corps.id}"
  route {
    cidr_block = "0.0.0.0/0"
    instance_id = "${aws_instance.us-east-1a-nat.id}"
  }
}

resource "aws_route_table" "us-east-1b-private" {
  vpc_id = "${aws_vpc.peace-corps.id}"
  route {
    cidr_block = "0.0.0.0/0"
    instance_id = "${aws_instance.us-east-1b-nat.id}"
  }
}

### Route Table Associations (Private Subnets)
resource "aws_route_table_association" "us-east-1a-private" {
  subnet_id = "${aws_subnet.us-east-1a-private.id}"
  route_table_id = "${aws_route_table.us-east-1a-private.id}"
}

resource "aws_route_table_association" "us-east-1b-private" {
  subnet_id = "${aws_subnet.us-east-1b-private.id}"
  route_table_id = "${aws_route_table.us-east-1b-private.id}"
}

### Routing Tables (Public Subnets)
resource "aws_route_table" "us-east-1-public" {
  vpc_id = "${aws_vpc.peace-corps.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }
}

resource "aws_route_table_association" "us-east-1a-public" {
  subnet_id = "${aws_subnet.us-east-1a-public.id}"
  route_table_id = "${aws_route_table.us-east-1-public.id}"
}

resource "aws_route_table_association" "us-east-1b-public" {
  subnet_id = "${aws_subnet.us-east-1b-public.id}"
  route_table_id = "${aws_route_table.us-east-1-public.id}"
}