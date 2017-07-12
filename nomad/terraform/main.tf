provider "triton" {}

variable "image_id" {
    type = "string"
    default = "12d043b9-7e10-411a-9b3b-ab6b7b28d063"
}

variable "machine_count" {
    default = 3
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
    }
}

resource "triton_firewall_rule" "www" {
    rule = "FROM any TO tag Role = www ALLOW tcp PORT 80"
    enabled = true
}
