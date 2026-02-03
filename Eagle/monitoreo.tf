###SNS Topic
resource "aws_sns_topic" "test_monitoring" {
  name = "test-monitoring"
}

resource "aws_sns_topic_subscription" "monitoring_test" {
  topic_arn = aws_sns_topic.test_monitoring.arn
  protocol  = "email"
  endpoint  = "arenasandres7@gmail.com"
}


###########Modulo de monitoreo para EKS########################
module "eks_monitoring" {
  source = "git::https://github.com/Andres-0903/Infra_AWS_Module_Monitoring_EKS.git//EKS?ref=1.0.1"

  cluster_name = toset(["Cluster_monitoring_Andres03"])

  project       = var.project
  environment   = var.environment
  sns_topic_arn = aws_sns_topic.test_monitoring.arn
}

###########Modulo de monitoreo para EC2########################
module "ec2_monitoring" {
  source = "git::https://github.com/Andres-0903/Infra_AWS_Module_Monitoring_EC2.git?ref=1.0.4"

  ec2_instances = {
    for name, ins in aws_instance.my-instance :
    name => { id = ins.id }

  }

  sns_topic_arn = [
    aws_sns_topic.test_monitoring.arn
  ]

}


