#!/bin/bash
set -eux

# wait for apt to be free (Ubuntu 24.04)
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

sed -i 's/<h1>Welcome to nginx!<\/h1>/<h1>Welcome to Homepage<\/h1>/' \
/var/www/html/index.nginx-debian.html

echo '<br><a href="/movies/">Visit For Movies</a>' >> /var/www/html/index.nginx-debian.html
echo '<br><a href="/shows/">Visit For Shows</a>' >> /var/www/html/index.nginx-debian.html
