FROM ubuntu:20.04
#MAINTAINER solofonore (solofonore@gmail.com)
RUN apt-get update
RUN apt-get install -y nginx 
RUN apt-get install -y git
EXPOSE 80
RUN rm -f /var/www/html/*
ADD html/ /var/www/html/
#RUN git clone https://github.com/diranetafen/static-website-example.git /var/www/html/
ENTRYPOINT ["/usr/sbin/nginx", "-g", "daemon off;"]
