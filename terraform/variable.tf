# Request for NBA API key from the user
variable "nba_api_key" {
  description = "Your NBA API key"
  type        = string
}


variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}
