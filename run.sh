#!/bin/sh

chown $USERNAME:$USERNAME /data
/usr/sbin/sshd
su - $USERNAME -c "/gogs/gogs web"