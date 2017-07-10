provider "triton" {}

variable "image_id" {
    type = "string"
    default = "58102f9b-1608-41dc-b69f-bd3f6177ef0b"
}

variable "machine_count" {
    default = 2
}

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

resource "triton_firewall_rule" "www" {
    rule = "FROM any TO tag Role = www ALLOW tcp PORT 80"
    enabled = true
}
