FROM debian:buster

RUN apt update && apt install -y nginx
RUN apt install vim -y

# COPY ./conf/nginx.conf /etc/nginx/nginx.conf

# COPY ./tools/setup_nginx.sh /
# RUN chmod +x /setup_nginx.sh

# EXPOSE 443/tcp

# ENTRYPOINT [ "./setup_nginx.sh" ]
