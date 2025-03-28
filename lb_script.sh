#!/bin/bash
# Update packages and install NGINX
sudo apt-get update -y
sudo apt-get install -y nginx

# Configure NGINX to load balance traffic to the two app instances
cat << 'EOL' | sudo tee /etc/nginx/sites-available/flask_app
upstream app_servers {
    server Add_App_Server_1:5000;
    server Add_App_Server_2:5000;
}

server {
    listen 80;

    location / {
        proxy_pass http://app_servers;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}

EOL


EOF
sudo systemctl stop nginx
sudo unlink /etc/nginx/sites-enabled/default

#sudo ln -s /etc/nginx/sites-available/flask_app /etc/nginx/sites-enabled/
# Restart NGINX to apply the configuration
#sudo systemctl restart nginx
