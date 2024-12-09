data "aws_region" "current" {}

resource "aws_vpc_ipam" "Main" {
  operating_regions {
    region_name = data.aws_region.current.name
  }
}

resource "aws_vpc_ipam_pool" "Main" {
  address_family = "ipv4"
  ipam_scope_id  = aws_vpc_ipam.Main.private_default_scope_id
  locale         = data.aws_region.current.name
}

resource "aws_vpc_ipam_pool_cidr" "Main" {
  ipam_pool_id = aws_vpc_ipam_pool.Main.id
  cidr         = "172.20.0.0/16"
}

resource "aws_vpc" "Main" {
  ipv4_ipam_pool_id   = aws_vpc_ipam_pool.Main.id
  ipv4_netmask_length = 28
  depends_on = [
    aws_vpc_ipam_pool_cidr.Main
  ]
  tags = {
    Name = "main"
  }
}
