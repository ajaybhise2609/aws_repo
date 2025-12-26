#!/bin/bash
set -e

# -------------------- UPDATE & INSTALL --------------------
apt update -y
apt install -y nginx certbot python3-certbot-nginx curl

# -------------------- AWS METADATA (DNS LEARNING) --------------------
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

AZ=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/placement/availability-zone)

REGION=${AZ::-1}

case "$REGION" in
  ap-south-1)
    REGION_NAME="Mumbai"
    ;;
  us-east-1)
    REGION_NAME="North Virginia"
    ;;
  *)
    REGION_NAME="Unknown Region"
    ;;
esac

# -------------------- WEB ROOT & INDEX --------------------
WEB_ROOT="/var/www/ajaydevops.co.in/html"
mkdir -p $WEB_ROOT
chown -R www-data:www-data /var/www/ajaydevops.co.in
chmod -R 755 /var/www/ajaydevops.co.in

cat <<EOF > $WEB_ROOT/index.html
<!DOCTYPE html>
<html>
<head>
    <title>DNS Routing Test - ajaydevops.co.in</title>
</head>
<body style="text-align:center; margin-top:100px; font-family:Arial;">
    <h1>DNS Routing Test</h1>
    <h2>Traffic reached server in:</h2>
    <h1 style="color:green;">$REGION</h1>
    <h2 style="color:blue;">$REGION_NAME</h2>
</body>
</html>
EOF

# -------------------- NGINX CONFIGURATION --------------------
cat <<EOF > /etc/nginx/sites-available/ajaydevops.co.in
server {
    listen 80;
    server_name ajaydevops.co.in www.ajaydevops.co.in \
                weighted.ajaydevops.co.in latency.ajaydevops.co.in \
                failover.ajaydevops.co.in geolocation.ajaydevops.co.in;

    root $WEB_ROOT;
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

# Enable site and remove default
rm -f /etc/nginx/sites-enabled/default
ln -sf /etc/nginx/sites-available/ajaydevops.co.in /etc/nginx/sites-enabled/

nginx -t
systemctl restart nginx
systemctl enable nginx

# -------------------- FIREWALL CONFIGURATION --------------------
# Open HTTP and HTTPS
if command -v ufw >/dev/null 2>&1; then
    ufw allow 'Nginx Full'
    ufw reload
fi

echo "Make sure AWS Security Group allows inbound ports 80 & 443"

# -------------------- CERTBOT SSL --------------------
echo "Requesting SSL certificates via Certbot..."
certbot --nginx \
  -d ajaydevops.co.in \
  -d www.ajaydevops.co.in \
  -d weighted.ajaydevops.co.in \
  -d latency.ajaydevops.co.in \
  -d failover.ajaydevops.co.in \
  -d geolocation.ajaydevops.co.in \
  --non-interactive \
  --agree-tos \
  -m ajbhise2609@gmail.com \
  --redirect || { echo "Certbot failed! Check domain resolution and firewall."; exit 1; }

# -------------------- VERIFY NGINX --------------------
nginx -t
systemctl restart nginx

echo "HTTPS setup complete! Your server is now accessible via HTTPS."
