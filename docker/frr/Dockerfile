FROM quay.io/frrouting/frr:10.2.1

# install some basic tools inside the container
# adjust this list based on your demands
RUN apk update; \
    apk add kea-dhcp4 bonding bridge iproute2 fping lldpd bash tcpdump openssh-server

RUN mkdir /run/kea; touch /var/log/kea/kea.log

# create default ssh key
RUN ssh-keygen -b 2048 -t rsa -N "" -f /etc/ssh/ssh_host_rsa_key -q

# add default password for root user
RUN echo "root:root" | chpasswd

COPY daemons /etc/frr/daemons
COPY vtysh.conf /etc/frr/vtysh.conf
COPY lldp.conf /etc/lldpd.d/lldpd.conf

RUN chown frr:frr /etc/frr/daemons /etc/frr/vtysh.conf

EXPOSE 22

#ENTRYPOINT /usr/sbin/sshd -f /etc/ssh/sshd_config && bash
