variable "AWS_DEFAULT_REGION"{
  type     = string
  nullable = false
}

variable "AWS_DEFAULT_ZONE_1"{
  type     = string
  nullable = false
}

variable "AWS_DEFAULT_ZONE_2"{
  type     = string
  nullable = false
}

variable "AWS_ACCESS_KEY_ID"{
  type     = string
  nullable = false
}

variable "AWS_SECRET_ACCESS_KEY"{
  type     = string
  nullable = false
}

variable "RDS_DATABASE"{
  type     = string
  nullable = false
}

variable "RDS_USER"{
  type     = string
  nullable = false
}

variable "RDS_PASSWORD"{
  type     = string
  nullable = false
}

variable "UNTAGGED_IMAGES"{
  type     = number
  nullable = false
  default = 1
}
