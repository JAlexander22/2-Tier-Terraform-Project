#!/bin/bash
# Update packages and install NGINX
sudo apt-get update -y
sudo apt-get install -y nginx
sudo apt install unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install


sleep 5

APP_PUBLIC_IPS=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=2_Tier_AppServer-*" --query "Reservations[*].Instances[*].PublicIpAddress" --output text)

IFS=$'\n' read -r -d '' -a APP_PUBLIC_IP_ARRAY <<< "$APP_PUBLIC_IPS"


sleep 5

# Configure NGINX to load balance traffic to the two app instances
cat << EOL | sudo tee /etc/nginx/sites-available/flask_app
upstream app_servers {
    server ${APP_PUBLIC_IP_ARRAY[0]}:5000;
    server ${APP_PUBLIC_IP_ARRAY[1]}:5000;
}

server {
    listen 80;

    location / {
        proxy_pass http://app_servers;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
}

EOL

sudo systemctl stop nginx
sudo unlink /etc/nginx/sites-enabled/default
sudo ln -s /etc/nginx/sites-available/flask_app /etc/nginx/sites-enabled/
# Restart NGINX to apply the configuration
sudo systemctl start nginx