#!/bin/bash
sudo apt-get update
sudo apt-get upgrade --assume-yes
sudo apt-get install docker -y
sudo apt-get install docker-compose -y
sudo apt-get install python3 -y
sudo apt-get install azure-cli -y
sudo docker pull docker.io/nofantasyno/car_number_recognition:latest
sudo docker pull docker.io/nofantasyno/gpio_api:latest
sudo git clone https://github.com/npogulyaev/car_numbers.git
sudo mv car_numbers/ main/
cd main
sudo iptables -A INPUT -p tcp --dport 3334 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 8000 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 8001 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 8888 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 9999 -j ACCEPT
sudo iptables -t nat -A PREROUTING -i tun0 -p tcp -m tcp --dport 8888 -j DNAT --to-destination 192.168.2.111:80
sudo iptables -t nat -A PREROUTING -i tun0 -p tcp -m tcp --dport 9999 -j DNAT --to-destination 192.168.2.112:80
sudo iptables -A FORWARD -d 192.168.2.111/32 -i tun0 -p tcp -m tcp --dport 80 -j ACCEPT
sudo iptables -A FORWARD -d 192.168.2.112/32 -i tun0 -p tcp -m tcp --dport 80 -j ACCEPT
sudo docker-compose up -d
sudo apt-get install --assume-yes iptables-persistent -y
sudo systemctl enable docker.service

