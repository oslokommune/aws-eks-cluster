module "admin" {
  source = "../secret-generated"
  env    = var.env
  prefix = var.prefix
  name   = "postgres/secret/${var.application}/master"
}

module "user" {
  source = "../secret-generated"
  env    = var.env
  prefix = var.prefix
  name   = "postgres/secret/${var.application}/user"
}

module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 2.0"

  identifier                      = "${var.prefix}-${var.env}-${var.application}-db"
  engine                          = "postgres"
  engine_version                  = var.engine_version
  instance_class                  = var.db_instance_type
  allocated_storage               = var.allocated_storage
  storage_encrypted               = true
  name                            = var.db_name
  username                        = var.admin_username
  password                        = module.admin.content
  port                            = "5432"
  vpc_security_group_ids          = [aws_security_group.incoming.id]
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  subnet_ids                      = var.subnets

  #aws rds describe-db-engine-versions --query "DBEngineVersions[].DBParameterGroupFamily"
  family                    = var.family
  major_engine_version      = var.major_engine_version
  final_snapshot_identifier = var.db_name

  maintenance_window         = "Mon:00:00-Mon:03:00"
  backup_window              = "03:00-06:00"
  auto_minor_version_upgrade = true

  deletion_protection = var.deletion_protection

  tags = {
    Environment = var.env
    Prefix      = var.prefix
  }
}

resource "aws_security_group" "postgres" {
  name        = "${var.prefix}-${var.env}-DatabaseEgressSecurityGroup"
  description = "Allow egress traffic to the database subnets"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 5432
    protocol    = "tcp"
    to_port     = 5432
    cidr_blocks = var.subnets_cidrs
  }

  tags = {
    Environment = var.env
    Prefix      = var.prefix
  }
}

resource "aws_security_group" "incoming" {
  name        = "${var.prefix}-${var.env}-${var.db_name}-PostgresAccessSecurityGroup"
  description = "Allow incoming traffic from provided security groups only"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 5432
    protocol        = "tcp"
    to_port         = 5432
    security_groups = [aws_security_group.postgres.id]
  }

  tags = {
    Environment = var.env
    Prefix      = var.prefix
  }
}

resource "aws_route53_record" "alias" {
  zone_id = var.hosted_zone_id
  name    = var.dns_name
  type    = "A"

  alias {
    evaluate_target_health = false
    name                   = module.db.this_db_instance_address
    zone_id                = module.db.this_db_instance_hosted_zone_id
  }
}
