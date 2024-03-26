# Provide a reference to your default VPC
resource "aws_default_vpc" "polygon_default_vpc" {
}

# Provide references to your default subnets
resource "aws_default_subnet" "polygon_default_subnet_1" {
  # Use your own region here but reference to subnet 1a
  availability_zone = var.AWS_DEFAULT_ZONE_1
}

resource "aws_default_subnet" "polygon_default_subnet_2" {
  # Use your own region here but reference to subnet 1b
  availability_zone = var.AWS_DEFAULT_ZONE_2
}
