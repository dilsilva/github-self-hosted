#Latest Spot instance
data "aws_ami" "amazonlinux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "image-id"
    values = [var.ami_id]
  }
}

resource "aws_instance" "gh-runner" {
  ami                  = data.aws_ami.amazonlinux.id
  instance_type        = var.runner_instance_type
  iam_instance_profile = aws_iam_instance_profile.runner_instance_profile.name
  user_data            = file("${path.module}/userdata.sh")
  vpc_security_group_ids  = [aws_security_group.gh-runner.id]

  # network_interface {
  #   network_interface_id = aws_network_interface.gh-runner.id
  #   device_index         = 0
  # }

  tags = merge(
    var.default_tags, {
      Name = "GH Self-hosted Runner"
  })

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 50
    delete_on_termination = true
  }
}
