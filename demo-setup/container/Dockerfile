FROM quay.io/mkoch-redhat/sap-ee:latest

LABEL maintainer="Markus Koch <mkoch@redhat.com>" 

WORKDIR /root
USER root

RUN dnf update -y && \
    dnf install -y lighttpd lighttpd-fastcgi php-fpm \
		net-tools man-db procps-ng &&\
    mkdir -p /run/lighttpd &&\
    rm -rf /etc/lighttpd  && mkdir /etc/lighttpd &&\
    mkdir -p /run/php-fpm &&\
    mkdir -p /var/log/php-fpm

# Update stable release from https://gitlab.com/ansible-ssa/collection-ansible_ssa-general/-/releases
COPY ansible_ssa-general*.tar.gz /root/ansible_ssa-general.tar.gz
RUN /usr/local/bin/ansible-galaxy install \
    /root/ansible_ssa-general.tar.gz \
    community.crypto \
    kubernetes.core \
    ansible.utils \
    -f -p /usr/share/ansible/collections/ansible_collections

# Install kubectl
# curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
ADD https://dl.k8s.io/release/v1.30.3//bin/linux/amd64/kubectl /usr/bin/kubectl
RUN chmod 755 /usr/bin/kubectl

COPY etc/lighttpd/* /etc/lighttpd/
COPY etc/php-fpm.conf /etc/php-fpm.conf
COPY etc/php-fpm.d/* /etc/php-fpm.d/
COPY htdocs/* /var/www/lighttpd/
COPY start.sh /usr/bin/

EXPOSE 8000/tcp
EXPOSE 8443/tcp

ENTRYPOINT /usr/bin/start.sh

#CMD ["start.sh"]


