variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type = number
  default = 8080
}

variable "default_http_port" {
  description = "The default port for HTTP requests"
  type = number
  default = 80
}
