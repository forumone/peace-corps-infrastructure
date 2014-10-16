variable "r53_zone_id" {}

resource "aws_route53_record" "nata" {
   zone_id = "${var.r53_zone_id}"
   name = "nata.peacecorps.18f.us"
   type = "A"
   ttl = "300"
   records = ["${aws_eip.us-east-1a-nat.public_ip}"]
}

resource "aws_route53_record" "natb" {
   zone_id = "${var.r53_zone_id}"
   name = "natb.peacecorps.18f.us"
   type = "A"
   ttl = "300"
   records = ["${aws_eip.us-east-1b-nat.public_ip}"]
}