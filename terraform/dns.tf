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

resource "aws_route53_record" "peacecorps-logging" {
   zone_id = "${var.r53_zone_id}"
   name = "peacecorps-logging.18f.us"
   type = "CNAME"
   ttl = "300"
   records = ["${aws_elb.logging.dns_name}"]
}

resource "aws_route53_record" "donate-peacecorps-dev" {
   zone_id = "${var.r53_zone_id}"
   name = "donate.peacecorps-dev.18f.us"
   type = "CNAME"
   ttl = "60"
   records = ["${aws_elb.webapp-dev.dns_name}"]
}

resource "aws_route53_record" "pay-donate-peacecorps-dev" {
   zone_id = "${var.r53_zone_id}"
   name = "pay.donate.peacecorps-dev.18f.us"
   type = "A"
   ttl = "60"
   records = ["${aws_eip.us-east-1a-nat.public_ip}", "${aws_eip.us-east-1b-nat.public_ip}"]
}

resource "aws_route53_record" "donate-peacecorps-internal" {
   zone_id ="Z3IW27V61YTKKQ"
   name = "donate.peacecorps.internal"
   type = "CNAME"
   ttl = "60"
   records = ["${aws_elb.webapp-dev.dns_name}"]
}

resource "aws_route53_record" "pay-donate-peacecorps-internal" {
   zone_id ="Z3IW27V61YTKKQ"
   name = "pay.donate.peacecorps.internal"
   type = "CNAME"
   ttl = "60"
   records = ["${aws_elb.paygov-dev.dns_name}"]
}

resource "aws_route53_record" "logging-peacecorps-internal" {
   zone_id ="Z3IW27V61YTKKQ"
   name = "logging.peacecorps.internal"
   type = "A"
   ttl = "60"
   records = ["${aws_instance.logging-1a.private_ip}", "${aws_instance.logging-1b.private_ip}"]
}

resource "aws_route53_record" "filetransfer-dev" {
   zone_id ="Z17MKCYB7Q35O8"
   name = "filetransfer-dev.beta.peacecorps.gov"
   type = "CNAME"
   ttl = "60"
   records = ["${aws_instance.admin-dev.public_dns}"]
}