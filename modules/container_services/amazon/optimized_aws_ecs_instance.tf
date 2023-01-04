locals{
    environment = "tutorial"

    vpc_1 = "vpc-8ba3-c183cab301fe"

    ecs_cluster_instance_type = "t2.micro"

    availability_zones = ["us-east-1a"]
    private_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
    public_subnets  = ["10.0.104.0/24", "10.0.105.0/24", "10.0.106.0/24"]
}

module "vpc" {
    source = "terraform-aws-modules/vpc/aws"
    version = "3.18.1"

    name = local.vpc_1
    cidr = "10.0.0.0/16"
    azs = local.availability_zones
    private_subnets = local.private_subnets
    public_subnets = local.public_subnets

    enable_nat_gateway = true
    single_nat_gateway = true
}

#depends on vpc
data "aws_ami" "ecs_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }
}

resource "aws_security_group" "test_group" {
  name        = "${local.vpc_1}"
  vpc_id      = module.vpc.vpc_id
  
  description = "creates a security group to test with"
}

module "app_ecs_cluster"{
    source = ".//optimized"
    name = "${local.vpc_1}-ecs-cluster"
    environment = local.environment

    image_id = data.aws_ami.ecs_ami.image_id
    instance_type = local.ecs_cluster_instance_type

    vpc_id = module.vpc.vpc_id
    subnet_ids = module.vpc.private_subnets
    security_group_ids = [aws_security_group.test_group.id]
    desired_capacity   = 1
    max_size           = 1
    min_size           = 1
}