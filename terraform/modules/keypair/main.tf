resource "aws_key_pair" "bastion_key" {
  key_name = "bastion_key"
  public_key = file("C:/Users/cjub.oh.CORP/.ssh/web_admin.pub")
//  public_key = "${var.bastion_key}"
}