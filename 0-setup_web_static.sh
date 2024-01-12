#!/usr/bin/env bash
# Setup Nginx to serve airbnb static files

if ! command -v nginx &> /dev/null; then
	sudo apt-get update
	sudo apt-get install -y nginx
fi
sudo mkdir -p /data/web_static/releases/test/
sudo mkdir -p /data/web_static/shared/

sudo touch /data/web_static/releases/test/index.html
sudo sh -c 'echo "<html>
	<head>
		<title>Welcome to Airbnb!</title>
	</head>
	<body>
		<h1>Success! The airbnb server block is working!</h1>
	</body>
</html>" > /data/web_static/releases/test/index.html'

if [ -L /data/web_static/current ]; then
	rm /data/web_static/current
fi

sudo ln -s /data/web_static/releases/test/ /data/web_static/current

sudo chown -R ubuntu:ubuntu /data

sudo tee /etc/nginx/sites-available/airbnb <<EOF
server {
	listen 80;
	listen [::]:80;
	server_name marymutuku.tech;

	root /var/www/html;

	location /hbnb_static {
		alias /data/web_static/current;
		index index.html index.htm;
	}
	error_page 404 /404.html;
	location = /404.html {
		root /usr/share/nginx/html;
		internal;
	}
	location / {
		try_files $uri $uri/ =404;
	}
}
EOF

# Create a symbolic link to enable the server block
sudo ln -s /etc/nginx/sites-available/airbnb /etc/nginx/sites-enabled/

# Restart Nginx
sudo service nginx restart
