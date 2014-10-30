resource "aws_db_subnet_group" "main" {
    name = "peacecorps-main-db-subnet-group"
    description = "Our main group of subnets"
    subnet_ids = ["${aws_subnet.us-east-1b-private.id}", "${aws_subnet.us-east-1a-private.id}"]
}