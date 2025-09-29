#!/bin/sh
/usr/sbin/sshd -f /etc/ssh/sshd_config && lldpd -O /etc/lldpd.d/lldpd.conf && bash