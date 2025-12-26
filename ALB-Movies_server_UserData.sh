#!/bin/bash
set -eux

# Wait for apt to be free (Ubuntu 24.04)
while fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do
  sleep 5
done

while fuser /var/lib/apt/lists/lock >/dev/null 2>&1; do
  sleep 5
done

apt update -y
apt install -y nginx

systemctl enable nginx
systemctl restart nginx

# Create movies directory
mkdir -p /var/www/html/movies

# Copy default index into movies
cp /var/www/html/index.nginx-debian.html /var/www/html/movies/index.html

# Update movies page
sed -i 's/<h1>Welcome to nginx!<\/h1>/<h1>Welcome to Movies<\/h1>/' \
/var/www/html/movies/index.html
