variable "environment" {}

variable "kafka_version" {}
variable "broker_type"   {}
variable "volume_size"   {}


data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_security_group" "default" {
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name = "group-name"
    values = ["default"]
  }
}

resource "aws_msk_cluster" "perch-photos" {
  cluster_name           = "perch-photos-${var.environment}"
  kafka_version          = var.kafka_version
  number_of_broker_nodes = 3

  broker_node_group_info {
    instance_type   = var.broker_type
    ebs_volume_size = var.volume_size
    client_subnets = slice(tolist(data.aws_subnet_ids.default.ids), 0, 3)

    security_groups = [data.aws_security_group.default.id]
  }
}

