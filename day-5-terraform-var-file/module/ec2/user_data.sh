#!/bin/bash
dnf update
dnf install nginx -y
systemctl start nginx
systemctl enable nginx

