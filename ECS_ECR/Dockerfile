FROM nginx:latest 
LABEL maintainer="someone@email.com"
RUN apt update -y && apt install -y curl net-tools jq 
COPY index.html /usr/share/nginx/html/
COPY scorekeeper.js /usr/share/nginx/html/
COPY style.css /usr/share/nginx/html/
COPY nginx_default.config /etc/nginx/sites-enabled/default
CMD ["nginx", "-g", "daemon off;"]
