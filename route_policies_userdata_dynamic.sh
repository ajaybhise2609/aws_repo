#!/bin/bash
set -e

# Update system
apt update -y
apt install -y nginx curl

# Get AWS region using IMDSv2
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

AZ=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/placement/availability-zone)

REGION=${AZ::-1}

# Create web root
mkdir -p /var/www/ajaydevops.co.in/html
chown -R ubuntu:ubuntu /var/www/ajaydevops.co.in
chmod -R 755 /var/www/ajaydevops.co.in

# Create index.html
cat <<EOF > /var/www/ajaydevops.co.in/html/index.html
<!DOCTYPE html>
<html>
<head>
  <title>Route 53 Test</title>
</head>
<body style="text-align:center;margin-top:100px;font-family:Arial;">
  <h1>✅ Route 53 Routing Test</h1>
  <h2>Served from AWS Region</h2>
  <h1>$REGION</h1>
</body>
</html>
EOF

# Nginx configuration
cat <<EOF > /etc/nginx/sites-available/ajaydevops.co.in
server {
    listen 80;
    server_name ajaydevops.co.in
                www.ajaydevops.co.in
                weighted.ajaydevops.co.in
                latency.ajaydevops.co.in
                failover.ajaydevops.co.in
                geolocation.ajaydevops.co.in;

    root /var/www/ajaydevops.co.in/html;
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

# Enable site
rm -f /etc/nginx/sites-enabled/default
ln -sf /etc/nginx/sites-available/ajaydevops.co.in /etc/nginx/sites-enabled/

nginx -t
systemctl restart nginx
systemctl enable nginx
