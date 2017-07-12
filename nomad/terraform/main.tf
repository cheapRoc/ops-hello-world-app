provider "triton" {}

variable "image_id_blue" {
    type = "string"
    default = "12d043b9-7e10-411a-9b3b-ab6b7b28d063"
}

variable "image_id_green" {
    type = "string"
    default = "c2011cb5-0e14-4467-a890-770cbb986bd8"
}

variable "machine_count_green" {
    default = 3
}

variable "machine_count_blue" {
    default = 3
}

resource "triton_machine" "app-blue" {
    count = "${var.machine_count_blue}"

    name = "hello-world-app-${count.index}-b"
    package = "g4-highcpu-512M"
    image = "${var.image_id_blue}"

    tags {
        Role = "www"
        Application = "Hello World"
        Version = "1.0"
        triton.cns.services = "hello-world"
    }
}

resource "triton_machine" "app-green" {
    count = "${var.machine_count_green}"

    name = "hello-world-app-${count.index}-g"
    package = "g4-highcpu-512M"
    image = "${var.image_id_green}"

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
