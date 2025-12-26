#!/bin/bash
sudo apt update
sudo apt install -y nginx

# Create the 'movies' directory if it doesn't exist
sudo mkdir -p /var/www/html/movies

# Move the 'index.nginx-debian.html' file to the 'movies' directory and rename it
sudo mv /var/www/html/index.nginx-debian.html /var/www/html/movies/index.nginx-debian.html

sudo sed -i 's/<h1>Welcome to nginx!<\/h1>/<h1>Welcome to Movies<\/h1>/' /var/www/html/movies/index.nginx-debian.html

# Add any additional content to the 'index.nginx-debian.html' file if needed
# For example:
# echo '<h1>Welcome to Homepage</h1>' | sudo tee /var/www/html/movies/index.nginx-debian.html

sudo systemctl start nginx
sudo systemctl enable nginx
