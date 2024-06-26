FROM debian:buster

# Update and install nginx and openssl
RUN	apt-get update -y \
	&& apt-get install -y nginx openssl \
	# Generate SSL certificate
	&& mkdir -p /etc/ssl/certs \
	&& openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/ssl/private/nginx-selfsigned.key \
	-out /etc/ssl/certs/nginx-selfsigned.crt \
	-subj "/C=CA/ST=QC/L=Quebec/O=42Network/OU=42Quebec/CN=login.42.fr" \
	# Clean up apt cache to reduce image size
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

# Copy custom Nginx configuration and script
COPY ./conf/nginx.conf /etc/nginx/conf.d

# Expose port 443 for HTTPS traffic
EXPOSE 443/tcp

# Set the entrypoint to start nginx
ENTRYPOINT ["nginx", "-g", "daemon off;"]
