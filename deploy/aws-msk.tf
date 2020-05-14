data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

resource "aws_msk_cluster" "perch-photos" {
  cluster_name           = "perch-photos-dev"
  kafka_version          = "2.4.1"
  number_of_broker_nodes = 3

  broker_node_group_info {
    instance_type   = "kafka.t3.small"
    ebs_volume_size = 20
    client_subnets = slice(tolist(data.aws_subnet_ids.default.ids), 0, 3)

    security_groups = ["sg-d6de2fb9"]
  }
}
