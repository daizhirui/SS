#!/bin/bash

echo 'Change port ... '
sudo sed  's/#Port\ 22/Port\ 8022/' /etc/ssh/sshd_config | tee new_sshd_config
cat new_sshd_config
#sudo mv new_sshd_config /etc/ssh/ssh_config

echo 'Disable PasswordAuthentication ... '
sudo sed  's/#PasswordAuthentication\ yes/PasswordAuthentication\ no/' | tee new_sshd_config
#sudo mv new_sshd_config /etc/ssh/sshd_config

sudo /etc/init.d/ssh restart
