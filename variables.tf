variable "app_metadata" {
  description = <<EOF
Nullstone automatically injects metadata from the app module into this module through this variable.
This variable is a reserved variable for capabilities.
EOF

  type    = map(string)
  default = {}
}

locals {
  app_security_group_id = var.app_metadata["security_group_id"]
  port                  = var.app_metadata["service_port"]
}

variable "protocol" {
  type        = string
  default     = "TCP"
  description = <<EOF
Specify the protocol to use for communication.
If you don't know, use TCP.
Options: TCP, TCP_UDP, UDP.
EOF

  validation {
    condition     = contains(["TCP", "TCP_UDP", "UDP"], var.protocol)
    error_message = "Invalid protocol. Protocol must be one of 'TCP', 'TCP_UDP', or 'UDP'."
  }
}

variable health_check_enabled {
  description = "Enable and configure health checking for the service from the load balancer."
  type        = bool
  default     = true
}

variable health_check_healthy_threshold {
  description = "The number of consecutive successful health checks required before considering an unhealthy target healthy."
  type        = number
  default     = 2
}

variable health_check_unhealthy_threshold {
  description = "The number of consecutive failed health checks required before considering a target unhealthy."
  type        = number
  default     = 2
}

variable health_check_interval {
  description = "The approximate amount of time, in seconds, between health checks of an individual target."
  type        = number
  default     = 5
}

variable health_check_timeout {
  description = "The amount of time, in seconds, during which no response means a failed health check."
  type        = number
  default     = 4
}

data "validation_error" "health_check_interval" {
  condition  = var.health_check_interval <= var.health_check_timeout
  summary = "health_check_interval must be greater than the health_check_timeout."
  details = <<EOF
For more details about configuring health checks on an AWS Load Balancer, see the AWS documentation:
https://docs.aws.amazon.com/elasticloadbalancing/latest/network/target-group-health-checks.html
EOF
}
