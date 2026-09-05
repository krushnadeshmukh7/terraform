#!/bin/bash

dnf update -y
dnf install -y httpd

systemctl start httpd
systemctl enable httpd

cat <<EOF > /usr/share/httpd/html/index.html
<h1>Hello from $HOSTNAME</h1>
EOF

systemctl restart httpd