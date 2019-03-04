#!/bin/bash

echo 'Change port ... '
sudo sed  's/#Port\ 22/Port\ 8022/' /etc/ssh/sshd_config &1> new_sshd_config
sudo mv new_sshd_config /etc/ssh/ssh_config

echo 'Disable PasswordAuthentication ... '
sudo sed  's/#PasswordAuthentication\ yes/PasswordAuthentication\ no/' &1> new_sshd_config
sudo mv new_sshd_config /etc/ssh/sshd_config

sudo /etc/init.d/ssh restart
