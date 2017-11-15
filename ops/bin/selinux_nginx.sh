#!/usr/bin/env bash
set -e
set -x

# Install required tools
yum install -y selinux-policy
yum install -y policycoreutils-python

# Restore socket state
# - name: ensure selinux permissions
#   command: restorecon -R -v /run/gunicorn.socket

# Create and install policy for nginx
# cat /var/log/audit/audit.log | grep nginx | grep denied | audit2allow
# cat /var/log/audit/audit.log | grep nginx | grep denied | audit2allow -m nginx
cd /home/deploy
cat /var/log/audit/audit.log | grep nginx | grep denied | audit2allow -M nginx
semodule -i nginx.pp

# Allow access to /web/static
chcon -Rt httpd_sys_content_t /web/static
