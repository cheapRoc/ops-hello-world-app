provider "triton" {}
provider "dnsimple" {}

variable "image_id" {
	type = "string"
	default = "c2808f17-51c8-400e-a1bf-c89083988399"	
}

variable "machine_count" {
	default = 2
}

variable "domain" {
	type = "string"
}

variable "subdomain" {
	type = "string"
}

resource "triton_machine" "app" {
	count = "${var.machine_count}" 

	name = "hello-world-app-${count.index}"
	package = "g4-highcpu-512M"
	image = "${var.image_id}"

	firewall_enabled = true

	tags {
		Role = "www"
		Application = "Hello World"
		Version = "1.0"
	}
}

resource "triton_firewall_rule" "www" {
	rule = "FROM any TO tag \"Role\" = \"www\" ALLOW tcp PORT 80"
	enabled = true
}

resource "dnsimple_record" "app" {
	count = "${var.machine_count}"

	domain = "${var.domain}"	
	name = "${var.subdomain}"
	
	type = "A"
	ttl = "3600"

	value = "${triton_machine.app.*.primaryip[count.index]}"
}
