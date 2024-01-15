#!/usr/bin/env bash
# Setup Nginx to serve Airbnb static files

# Install Nginx if not already installed
if ! command -v nginx &> /dev/null; then
	sudo apt-get update
	sudo apt-get install -y nginx
	sudo service nginx start
fi

# Create directory structure for static files
sudo mkdir -p /data/web_static/releases/test/
sudo mkdir -p /data/web_static/shared/

# Create a simple index.html file
sudo sh -c 'echo "<html>
  <head>
  </head>
  <body>
	Holberton School
  </body>
</html>" > /data/web_static/releases/test/index.html'

# Remove existing symbolic link if present
if [ -L /data/web_static/current ]; then
	rm /data/web_static/current
fi

# Create a symbolic link to the test release
sudo ln -sf /data/web_static/releases/test/ /data/web_static/current

# Set ownership to ubuntu user and group
sudo chown -R ubuntu:ubuntu /data

# Configure Nginx hbnb_static server block
sudo touch /etc/nginx/sites-available/hbnb_static
sudo sh -c 'echo "server {
	listen 80;
	listen [::]:80;
	root   /var/www/html;
	index  index.html index.htm;

	location /hbnb_static {
		alias /data/web_static/current;
		index index.html index.htm;
	}

	location /redirect_me {
		return 301 https://www.youtube.com/watch?v=QH2-TGUlwu4;
	}

	error_page 404 /404.html;
	location /404 {
	  root /var/www/html;
	  internal;
	}
}" > /etc/nginx/sites-available/hbnb_static'

# Restart Nginx
sudo service nginx restart
