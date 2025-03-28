# 2-Tier Terraform Project

## Task: Manually jump on the Nginx Server and update the IP to match the 2 App Server
## Intrustions

### Jump into admin 
_command:_ sudo su

### Check is an exist flask_app is in sites-enabled directory
_command:_ ls /etc/nginx/sites-enabled/

- If it exist, remove the file using _command:_ rm /etc/nginx/sites-enabled/flask_app

### Modify flask_app config file & update with IP address
nano /etc/nginx/sites-available/flask_app
### crtl + X to leave and save nao Editor

# Link sites/available/flask_app with sites/enabled
sudo ln -s /etc/nginx/sites-available/flask_app /etc/nginx/sites-enabled/

### Restart Nginx
sudo systemctl restart nginx

