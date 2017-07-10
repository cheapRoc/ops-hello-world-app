provider "triton" {}

variable "image_id" {
    type = "string"
    default = "37486be0-9e6e-444d-b71d-69fa3088a053"
}

variable "machine_count" {
    default = 2
}

# variable "domain" {
#     type = "string"
# }

# variable "subdomain" {
#     type = "string"
# }

resource "triton_machine" "app" {
    count = "${var.machine_count}"

    name = "hello-world-app-${count.index}"
    package = "g4-highcpu-512M"
    image = "${var.image_id}"

    tags {
        Role = "www"
        Application = "Hello World"
        Version = "1.0"
        triton.cns.services = "hello-world"
    }
}

# resource "dnsimple_record" "app" {
#     count = "${var.machine_count}"

#     domain = "${var.domain}"
#     name = "${var.subdomain}"

#     type = "A"
#     ttl = "3600"

#     value = "${triton_machine.app.*.primaryip[count.index]}"
# }

resource "triton_firewall_rule" "www" {
    rule = "FROM any TO tag Role = www ALLOW tcp PORT 80"
    enabled = true
}
