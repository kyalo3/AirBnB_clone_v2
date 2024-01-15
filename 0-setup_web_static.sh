#!/bin/bash

# Install Nginx if not already installed
if ! command -v nginx &> /dev/null; then
	sudo apt-get update
	sudo apt-get install -y nginx
fi

# Create necessary directories
sudo mkdir -p /data/web_static/releases/test/
sudo mkdir -p /data/web_static/shared/

# Create a fake HTML file for testing
sudo tee /data/web_static/releases/test/index.html <<EOF
<html>
  <head>
  </head>
  <body>
	Holberton School
  </body>
</html>
EOF

# Create a symbolic link /data/web_static/current
if [ -L /data/web_static/current ]; then
	sudo rm /data/web_static/current
fi
sudo ln -s /data/web_static/releases/test/ /data/web_static/current

# Give ownership of the /data/ folder to the ubuntu user and group
sudo chown -R ubuntu:ubuntu /data

# Update Nginx configuration
sudo tee /etc/nginx/sites-available/airbnb <<EOF
server {
	listen 80;
	listen [::]:80;
	server_name localhost;

	root /var/www/html;

	location /hbnb_static/ {
	    alias /data/web_static/current/;
	    index index.html index.htm;
	}

	error_page 404 /404.html;
	location = /404.html {
	    root /usr/share/nginx/html;
	    internal;
	}

	location / {
	    try_files \$uri \$uri/ =404;
	}
}
EOF

# Create a symbolic link to enable the server block
sudo ln -sf /etc/nginx/sites-available/airbnb /etc/nginx/sites-enabled/

# Restart Nginx
sudo service nginx restart
