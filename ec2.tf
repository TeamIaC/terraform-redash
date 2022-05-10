# EC2
resource "aws_instance" "ec2_instance" {
    ami = "ami-060741a96307668be"
    instance_type = "t2.small"
    # パブリックサブネットに配置
    subnet_id = aws_subnet.public_subnet.id
    vpc_security_group_ids = [aws_security_group.security_group.id]
    key_name               = aws_key_pair.key_pair.id
    tags = {
        Name = "redash"
    }
}

# セキュリティーグループ
resource "aws_security_group" "security_group" {
    name = "redash-sg"
    vpc_id = aws_vpc.vpc.id
    tags = {
        Name = "redash-sg"
    }
}

# 22番ポート開放
resource "aws_security_group_rule" "accept22" {
    security_group_id = aws_security_group.security_group.id
    type              = "ingress"
    cidr_blocks       = ["0.0.0.0/0"]
    from_port         = 22
    to_port           = 22
    protocol          = "tcp"
}

# 80番ポート開放
resource "aws_security_group_rule" "accept80" {
    security_group_id = aws_security_group.security_group.id
    type = "ingress"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 80
    to_port = 80
    protocol = "tcp"
}

# 443番ポート開放
resource "aws_security_group_rule" "accept443" {
    security_group_id = aws_security_group.security_group.id
    type = "ingress"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 443
    to_port = 443
    protocol = "tcp"
}

# アウトバウンドルール
resource "aws_security_group_rule" "out_all" {
    security_group_id = aws_security_group.security_group.id
    type              = "egress"
    cidr_blocks       = ["0.0.0.0/0"]
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
}

# Elastic IP
resource "aws_eip" "eip" {
    instance = aws_instance.ec2_instance.id
    vpc      = true
}

# Key Pair
resource "aws_key_pair" "key_pair" {
    # キーペアの名前
    key_name   = "example"
    # 現時点ではユーザー側でキーペア生成しなければならない
    # ssh-keygen -t rsa -f example -N ''
    # ssh -i ./example ec2-user@35.77.206.159
    public_key = file("./example.pub")
}
