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

# Create shows directory
mkdir -p /var/www/html/shows

# Copy default index into shows
cp /var/www/html/index.nginx-debian.html /var/www/html/shows/index.html

# Update shows page content
sed -i 's/<h1>Welcome to nginx!<\/h1>/<h1>Welcome to Shows<\/h1>/' \
/var/www/html/shows/index.html
