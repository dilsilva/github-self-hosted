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

  subnet_id               = var.subnet_id
  vpc_security_group_ids  = [aws_security_group.gh-runner.id]

  key_name = aws_key_pair.runner.key_name

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

resource "aws_key_pair" "runner" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDJaDTgLeCoQqvOD2Hbityz0WD+/jmLY7Wpy4Zmu81S2ejbSiU2AHAZil0KhCJzMDtoZfhbsntRCU1i5tIVnCyT1XOptMXrMn3h8LqVHjc7KqMZkOnPHFjUm/JBgAsxyM4NOVIgLykH4QRotRCBtMhjPWwDfpdgrlFciEmq6NEiyVkNRWT2RJ2FV9JqD15vs9i3Q/whmR6nbqb7o5HCPRz6s2wkQonsjP16v+MpPZjFswGMJxcsL4ZcKN4bvsElhwYVGDSS1R6Z4cn/CSU8bluRPIHWUSEZsW9vME7h32j2v79qBp5I8ACJbyQC2VstoHRWSOoVt/sQE3gLjGBd+goi7sQCHDVQnhstSPuxZOdEuxGDANSEyyo7TCiZrfRVZqcDtmUi1WmTkAzpvFjQYZT8hwIxsVbp2VG3tP6UwH3DH8ofxd6eIOvH27bxlbwzbOAkNG9/rwT4kGfyZZ2D8R9aH9PFXeeohiQkJegyRzzIWzHhxtL2v5i2Mxcbtnhj/kdzK0GUUymDjO3LK7+UW4kGEKCX/KxuuWWsrlrKPTMZu1x3nsDJD+gUgC33GOkY7zO0hSj4kXVxpPN+Q5RngNB9rHF7RPRMuS7TCF0V6ZfTRh9Q6DNDrGOrzlLmJj2yA0vB/V2rsLRA/TXVpTlE91/j/1vxsIFuZ99NspCUwbBABw== dilsilva.diego@gmail.com"
}