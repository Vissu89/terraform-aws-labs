terraform {
    required_providers {
        random = {
            source = "hashicorp/random"
            version = "~> 3.6"
        }
        local = {
            source = "hashicorp/local"
            version = "~> 2.5"
        }
    }
}

resource "random_pet" "server" {
    length = 2
}

resource "local_file" "hello" {
    filename = "${path.module}/hello.txt"
    content = "Server name: ${random_pet.server.id}\n"
}

output "server_name" {
    value = random_pet.server.id
}
