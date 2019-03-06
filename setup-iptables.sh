###### iptables ######
# --flush: delete all rules in all chains
sudo iptables -F
# --delete-chain: delete all user-defined chain
sudo iptables -X
# operate mangle table
sudo iptables --table mangle --flush
sudo iptables --table mangle --delete-chain

# create default rules
sudo iptables -P INPUT DROP
sudo iptables -P OUTPUT ACCEPT
## this server is not a router
sudo iptables -P FORWARD DROP

# create TCP UDP ICMP chain
sudo iptables -N TCP 
sudo iptables -N UDP 
sudo iptables -N ICMP

# TCP chain
## SSH at 8022
sudo iptables -A TCP -p tcp --dport 8022 -j ACCEPT
## SS at 8060
sudo iptables -A TCP -p tcp --dport 8060 -j ACCEPT

# UDP chain
## SS at 8060
sudo iptables -A UDP -p udp --dport 8060 -j ACCEPT

# ICMP chain
## ping
sudo iptables -A ICMP -p icmp --icmp-type echo-request -j ACCEPT
sudo iptables -A ICMP -p icmp --icmp-type echo-reply -j ACCEPT

# INPUT chain
## allow internal tracking to evaluate packets as part of larger connections
## that is, allow leagal input packet
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
## accept local loopback interface: -i lo
sudo iptables -A INPUT -i lo -j ACCEPT
## refuse invalid packets
sudo iptables -A INPUT -m conntrack --ctstate INVALID -j DROP
## jump to TCP chain
sudo iptables -A INPUT -p tcp --syn -m conntrack --ctstate NEW -j TCP 
## jump to UDP chain
sudo iptables -A INPUT -p udp -m conntrack --ctstate NEW -j UDP 
## jump to ICMP chain
sudo iptables -A INPUT -p icmp -m conntrack --ctstate NEW -j ICMP
## attemping to establish a TCP connection on a closed port results in a TCP RST response
sudo iptables -A INPUT -p tcp -j REJECT --reject-with tcp-reset
## attemping to reach a closed UDP port will result in an ICMP "port unreachable" message
sudo iptables -A INPUT -p udp -j REJECT --reject-with icmp-port-unreachable
## all other packets, reject
sudo iptables -A INPUT -j REJECT --reject-with icmp-port-unreachable


###### ip6tables ######
sudo ip6tables -F
sudo ip6tables -P INPUT DROP
sudo ip6tables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo ip6tables -A INPUT -p tcp --dport 8022 -j ACCEPT
sudo ip6tables -P FORWARD DROP
sudo ip6tables -P OUTPUT ACCEPT


###### make iptables persistent ######
if $(which netfilter-persistent); then 
    echo 'yes! find iptables-persistent!\n'
else 
    echo 'try to install iptables-persistent now...\n'
    sudo apt install iptables-persistent -y
fi

sudo netfilter-persistent save
