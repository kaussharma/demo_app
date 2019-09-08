
resource "local_file" "host_inventory" {
  count    = var.instance_count
  content  = templatefile("templates/host_inventory/host_inventory.tpl", { hostname = "demo_instance.${count.index}", ip_address = "${element(aws_instance.demo_instance.*.public_ip, count.index)}", availability_zone = "${element(aws_instance.demo_instance.*.availability_zone, count.index)}" })
  filename = "../ansible/host_inventory_services"
}

resource "local_file" "extra_vars" {
  content  = templatefile("templates/ansible/extra-vars.json.tmpl", { ansible_stage = var.stage })
  filename = "../ansible/extra-vars.json"
}


resource "local_file" "local_public_key" {
  filename          = var.DESTINATION_SSH_KEY_PUBLIC
  sensitive_content = aws_ssm_parameter.instance_public_key.value
  provisioner "local-exec" {
    command = "chmod 600 ${var.DESTINATION_SSH_KEY_PUBLIC}"
  }
}

resource "local_file" "local_private_key" {
  filename          = var.DESTINATION_SSH_KEY_PRIVATE
  sensitive_content = aws_ssm_parameter.instance_private_key.value
  provisioner "local-exec" {
    command = "chmod 600 ${var.DESTINATION_SSH_KEY_PRIVATE}"
  }
}

