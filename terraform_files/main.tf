module "network_module" {
  source         = "./Network"
  vpc_cidr       = "10.4.0.0/16"
  vpc_name       = "ansible-terraform-mamdouh-vpc"
  subnet_az      = ["us-east-1a", "us-east-1b"]
  public-cidrs   = ["10.4.0.0/28", "10.4.1.0/28"]
  private-cidrs  = ["10.4.2.0/28", "10.4.3.0/28"]
  nat_subnet     = "10.4.0.0/28"
  route_table_in = "0.0.0.0/0"
}

module "public_SG" {
  source       = "./SecurityGroup"
  SG_name      = "public-SG"
  outbound_ips = ["0.0.0.0/0"]
  http_ips     = ["0.0.0.0/0"]
  ssh_ips      = ["0.0.0.0/0"]

  vpc_id = module.network_module.vpc-id
}

# module "private_SG" {
# source   = "./SecurityGroup"
# SG_name = "private-SG"
# outbound_ips = ["0.0.0.0/0"]
# http_ips = []
# ssh_ips = ["0.0.0.0/0"]
# vpc_id = module.network_module.vpc-id

# }

module "public_ec2_1" {
  source          = "./ec2"
  ec2_ami         = "ami-06878d265978313ca"
  ec2_type        = "t2.micro"
  SG_id           = [module.public_SG.SG-ID]
  instance_name   = "JumpHost"
  ec2_subnet      = module.network_module.public-subnet-az1-id
  pub_ip_state    = "true"
  key_pair        = "mamdouh-ansible"
  proxy_existance = "true"
  proxy_pass_url  = "" #module.proxy_alb.lb-dns
  bastion_host_ip = ""
  instnace-number = " 1 "
  # remote-commands = [
  #   "sudo apt update -y",
  #   "sudo apt install -y nginx",
  #   "echo 'server { \n listen 80 default_server; \n  listen [::]:80 default_server; \n  root /var/www/html; \n  index index.html index.htm index.nginx-debian.html; \n  server_name _; \n  location / { \n  proxy_pass http://${module.private_alb.lb-dns}; \n try_files $uri $uri/ =404; \n   } \n}' > default",
  #   "sudo mv default /etc/nginx/sites-available/default",
  #   "sudo systemctl stop nginx",
  #   "sudo systemctl start nginx",
  # ]


}

# module "public_ec2_2" {
#   source          = "./ec2"
#   ec2_ami         = "ami-06878d265978313ca"
#   ec2_type        = "t2.micro"
#   SG_id           = [module.public_SG.SG-ID]
#   instance_name   = "proxy 2"
#   ec2_subnet      = module.network_module.public-subnet-az2-id
#   pub_ip_state    = "true"
#   key_pair        = "mamdouh-ansible"
#   proxy_existance = "true"
#   proxy_pass_url  = module.proxy_alb.lb-dns
#   bastion_host_ip = ""
#   instnace-number = " 2 "

#   remote-commands = [
#     "sudo apt update -y",
#     "sudo apt install -y nginx",
#     "echo 'server { \n listen 80 default_server; \n  listen [::]:80 default_server; \n  root /var/www/html; \n  index index.html index.htm index.nginx-debian.html; \n  server_name _; \n  location / { \n  proxy_pass http://${module.private_alb.lb-dns}; \n try_files $uri $uri/ =404; \n   } \n}' > default",
#     "sudo mv default /etc/nginx/sites-available/default",
#     "sudo systemctl stop nginx",
#     "sudo systemctl start nginx",
#   ]

# }

# module "private_ec2_1" {
#   source          = "./ec2"
#   ec2_ami         = "ami-0dfcb1ef8550277af"
#   ec2_type        = "t2.medium"
#   SG_id           = [module.public_SG.SG-ID]
#   instance_name   = "redhat-nexus"
#   ec2_subnet      = module.network_module.private-subnet-az1-id
#   pub_ip_state    = "false"
#   key_pair        = "mamdouh-ansible"
#   proxy_existance = "false"
#   proxy_pass_url  = module.private_alb.lb-dns
#   bastion_host_ip = module.public_ec2_1.public_ip
#   instnace-number = " 1 "
#   # remote-commands = [
#   #   "sudo apt update -y",
#   #   "sudo apt install -y nginx",
#   #   "echo 'Hello from Nginx Page , from User data inside Terraform with Private instance 111111111111111111  !!' > index.html",
#   #   "sudo mv index.html /var/www/html/index.html",
#   #   "sudo systemctl restart nginx",
#   # ]
# }

module "private_ec2_2" {
  source          = "./ec2"
  ec2_ami         = "ami-06878d265978313ca"
  ec2_type        = "t2.medium"
  SG_id           = [module.public_SG.SG-ID]
  instance_name   = "ubuntu-sonerqube"
  ec2_subnet      = module.network_module.private-subnet-az2-id
  pub_ip_state    = "false"
  key_pair        = "mamdouh-ansible"
  proxy_existance = "false"
  proxy_pass_url  = module.private_alb.lb-dns
  bastion_host_ip = module.public_ec2_1.public_ip
  instnace-number = " 2 "
  # remote-commands = [
  #   "sudo apt update -y",
  #   "sudo apt install -y nginx",
  #   "echo 'Hello from Nginx Page , from User data inside Terraform with Private Instance 222222222222222222 !! ' > index.html",
  #   "sudo mv index.html /var/www/html/index.html",
  #   "sudo systemctl restart nginx",
  # ]
}

# module "proxy_alb" {
#   source                     = "./lb"
#   vpc_id                     = module.network_module.vpc-id
#   allow_all_ipv4_cidr_blocks = ["0.0.0.0/0"]
#   lb-SGG                     = module.public_SG.SG-ID
#   lb_name                    = "proxy-lb"
#   lb_internal_or_not         = "false"
#   lb_subnets_ids             = [module.network_module.public-subnet-az2-id, module.network_module.public-subnet-az1-id]
#   target_group_name          = "proxies-TG"
#   target_group_type          = "instance"
#   ec2s_instance_ids          = [module.public_ec2_1.instance-id, module.public_ec2_2.instance-id]
# }

module "private_alb" {
  source                     = "./lb"
  vpc_id                     = module.network_module.vpc-id
  allow_all_ipv4_cidr_blocks = ["0.0.0.0/0"]
  lb-SGG                     = module.public_SG.SG-ID
  lb_name                    = "private-lb"
  lb_internal_or_not         = "false"
  lb_subnets_ids             = [module.network_module.public-subnet-az2-id, module.network_module.public-subnet-az1-id]

  target_group_name = "ansible-TG"
  target_group_type = "instance"
  nexus_instance_id = ""
  # nexus_instance_id     = module.private_ec2_1.instance-id
  sonarqube_instance_id = module.private_ec2_2.instance-id
}

# module "proxies_ASG" {
#   source                    = "./asg"
#   img_id                    = "ami-06878d265978313ca"
#   instance_type             = "t2.micro"
#   instance_template_version = "$Latest"
#   ASG_LT_SG = module.public_SG.SG-ID
#   key_pair_name = "mamdouh-ansible"
#   remote_commands = [
#     "sudo apt update -y",
#     "sudo apt install -y nginx",
#     "echo 'server { \n listen 80 default_server; \n  listen [::]:80 default_server; \n  root /var/www/html; \n  index index.html index.htm index.nginx-debian.html; \n  server_name _; \n  location / { \n  proxy_pass http://${module.private_alb.lb-dns}; \n try_files $uri $uri/ =404; \n   } \n}' > default",
#     "sudo mv default /etc/nginx/sites-available/default",
#     "sudo systemctl stop nginx",
#     "sudo systemctl start nginx",
#   ]
#   TG_arn = [module.proxy_alb.TG_arn]
#   policy_name = "Proxies ASG 1"
#   scaling_adjustment = "1"
#   depends = module.proxy_alb
#   ASG_name                  = "proxy_Auto_Scaling_Group"
#   pub_ip_state_ASG          = "true"
#   ASG_subnets_id             = [module.network_module.public-subnet-az1-id, module.network_module.public-subnet-az1-id]
# }
