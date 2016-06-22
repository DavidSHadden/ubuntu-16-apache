FROM 1and1internet/ubuntu-16:latest
MAINTAINER james.wilkins@1and1.co.uk
ARG DEBIAN_FRONTEND=noninteractive
COPY files /
RUN \
  apt-get update && apt-get install -o Dpkg::Options::=--force-confdef -y apache2 && \
  a2enmod rewrite ssl headers && \
  rm -rf /var/lib/apt/lists/* && \
  sed -i -e 's/Listen 80/Listen 8080/g' /etc/apache2/ports.conf && \
  sed -i -e 's/DirectoryIndex index.html index.cgi index.pl index.php index.xhtml index.htm/DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm/g' /etc/apache2/mods-available/dir.conf && \
  mkdir -p /var/lock/apache2 && mkdir -p /var/run/apache2 && \
  chmod -R 777 /var/log/apache2 /var/lock/apache2 /var/run/apache2 /var/www && \
  echo "SSLProtocol ALL -SSLv2 -SSLv3" >> /etc/apache2/apache2.conf && \
  sed -i -e 's/Listen 443/#Listen 8443/g' /etc/apache2/ports.conf && \
  chmod -R 755 /hooks /init && \
  chmod 666 /etc/apache2/ports.conf && \
  chmod -R 755 /etc/apache2/sites-available && \
  chmod -R 777 /etc/apache2/sites-enabled
WORKDIR /var/www

EXPOSE 8080 8443
