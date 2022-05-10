# terraform-redash-sample

こちらのTerraformで今すぐRedashを始められます

https://redash.io/help/open-source/setup#-AWS

鍵を生成する

```
ssh-keygen -t rsa -f example -N ''
```
環境を生成

```
terraform apply
```
SSH接続する

```
ssh -i ./example ec2-user@<Public IP>
```

環境を削除するとき

```
terraform destroy
```
