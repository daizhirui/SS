#!/bin/bash

echo 'Change port ... '
sudo sed -e 's/#Port\ 22/Port\ 8022/' /etc/ssh/sshd_config &> new_sshd_config
sudo mv new_sshd_config /etc/ssh/ssh_config

echo 'Disable PasswordAuthentication ... '
sudo sed -e 's/#PasswordAuthentication\ yes/PasswordAuthentication\ no/' > new_sshd_config
sudo mv new_sshd_config /etc/ssh/sshd_config

sudo /etc/init.d/ssh restart
