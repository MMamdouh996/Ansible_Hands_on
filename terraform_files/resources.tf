# resource "local_file" "tf-nginx-p-ud" {
#   filename        = "./nginx-public-userdata"
#   content         = <<EOF
# sudo apt update
# sudo apt install -y nginx
# sudo echo "<h1>hello from nginx public page $(hostname -f)</h1>" > /var/www/html/index.html
# sudo systemctl restart nginx
#   EOF
#   file_permission = "744"
# }