variable "region" {
  type    = string
  default = "us-east-1"
}

variable "alert_email" {
  type        = string
  description = "Email that receives budget alerts"
}

variable "budget_limit" {
  type        = number
  default     = 150
  description = "Total credit budget in USD"
}

variable "budget_alert_amounts" {
  type        = list(number)
  default     = [50, 100, 130]
  description = "Absolute USD amounts that trigger an email"
}
