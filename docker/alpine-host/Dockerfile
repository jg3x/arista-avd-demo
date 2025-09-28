FROM alpine:3.19.7

# install some basic tools inside the container
# adjust this list based on your demands
RUN apk update; \
    apk add bonding util-linux-misc dhcp dhclient bridge iproute2 fping lldpd bash tcpdump openssh-server

RUN mkdir /run/dhcp; touch /var/lib/dhcp/dhcpd.leases

# create default ssh key
RUN ssh-keygen -b 2048 -t rsa -N "" -f /etc/ssh/ssh_host_rsa_key -q

# add default password for root user
RUN echo "root:root" | chpasswd

EXPOSE 22

COPY entrypoint.sh /root/entrypoint.sh

RUN chmod +x /root/entrypoint.sh

ENTRYPOINT [ "/root/entrypoint.sh" ]
