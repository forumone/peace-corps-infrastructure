resource "aws_s3_bucket" "logs" {
    bucket = "peacecorps-logs"
    acl = "private"
}