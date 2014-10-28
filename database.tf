resource "aws_db_subnet_group" "peace-corps-db-subnet" {
    name = "Peace Corps DB Subnet"
    description = "Subnets used for Peace Corps RDS"
    subnet_ids = ["${aws_subnet.us-east-1a-private.id}", "${aws_subnet.us-east-1b-private.id}"]
}

resource "aws_db_instance" "peace-corps-dev" {
    identifier = "mydb-rds"
    allocated_storage = 10
    engine = "mysql"
    engine_version = "5.6.17"
    instance_class = "db.t1.micro"
    name = "mydb"
    username = "foo"
    password = "bar"
    security_group_names = ["${aws_db_security_group.bar.name}"]
        subnet_group_name = "my_database_subnet_group"
}