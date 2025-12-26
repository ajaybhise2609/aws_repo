#!/bin/bash
set -e

apt update -y
apt install -y nginx

REGION="us-east-1"

mkdir -p /var/www/ajaydevops.co.in/html
chown -R ubuntu:ubuntu /var/www/ajaydevops.co.in
chmod -R 755 /var/www/ajaydevops.co.in

cat <<EOF > /var/www/ajaydevops.co.in/html/index.html
<html>
<body style="text-align:center;margin-top:100px;font-family:Arial;">
  <h1>✅ Route 53 Routing Test</h1>
  <h2>Served from AWS Region</h2>
  <h1>$REGION</h1>
</body>
</html>
EOF

rm -f /etc/nginx/sites-enabled/default
systemctl restart nginx
systemctl enable nginx
