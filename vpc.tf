# VPC
resource "aws_vpc" "vpc" {
    cidr_block                       = "10.0.0.0/16"
    enable_dns_hostnames             = true
    enable_dns_support               = true
    instance_tenancy                 = "default"
    tags                             = {
        "Name" = "redash"
    }
}

# パブリックサブネット
resource "aws_subnet" "public_subnet" {
    availability_zone               = "ap-northeast-1a"
    cidr_block                      = "10.0.0.0/24"
    # サブネットで起動したインスタンスにパブリックIPを許可する
    map_public_ip_on_launch = true
    tags                            = {
        "Name" = "redash_public_subnet"
    }
    vpc_id                          = aws_vpc.vpc.id
}

# プライベートサブネット
resource "aws_subnet" "private_subnet" {
    availability_zone               = "ap-northeast-1c"
    cidr_block                      = "10.0.1.0/24"
    # いらない
    map_public_ip_on_launch = true
    tags                            = {
        "Name" = "redash_private_subnet"
    }
    vpc_id                          = aws_vpc.vpc.id
}

# インターネットゲートウェイ
resource "aws_internet_gateway" "igw" {
    tags     = {
        "Name" = "redash"
    }
    vpc_id   = aws_vpc.vpc.id
}

# ルートテーブル
resource "aws_route_table" "route_table" {
    route {
        cidr_block                 = "0.0.0.0/0"
        gateway_id                 = aws_internet_gateway.igw.id
    }
    tags             = {
        "Name" = "redash"
    }
    vpc_id           = aws_vpc.vpc.id
}

# ルートテーブルをパブリックサブネットに紐付け
# これでパブリックサブネットが外部に公開された状態に
resource "aws_route_table_association" "public_subnet_association" {
    route_table_id = aws_route_table.route_table.id
    subnet_id      = aws_subnet.public_subnet.id
}