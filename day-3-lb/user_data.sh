#!/bin/bash
dnf update -y
dnf install -y httpd
systemctl start httpd
systemctl enable httpd
rm -rf /usr/share/httpd/html/index.html
echo <h1> hello from $HOSTNAME </h1> > /usr/share/httpd/html/index.html

systemctl restart httpd