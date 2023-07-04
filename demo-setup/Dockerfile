FROM registry.access.redhat.com/ubi9/ubi:latest

LABEL maintainer="Markus Koch <mkoch@redhat.com>" 

RUN dnf update -y && \
    rpm --import https://packages.microsoft.com/keys/microsoft.asc && \
    dnf install -y https://packages.microsoft.com/config/rhel/9.0/packages-microsoft-prod.rpm &&\
    dnf install -y python3 python3-pip jq azure-cli && \
    dnf clean all && \
    pip3 install -q ansible==8.1.0 &&\
    pip3 install -r /usr/local/lib/python3.9/site-packages/ansible_collections//azure/azcollection/requirements-azure.txt 

RUN mkdir /etc/ansible &&\
    echo "[defaults]" > /etc/ansible/ansible.cfg &&\
    echo "stdout_callback = yaml" >> /etc/ansible/ansible.cfg

WORKDIR /root
ADD setup ./setup

WORKDIR /root/setup
ENTRYPOINT /bin/bash
