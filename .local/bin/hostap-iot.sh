nmcli radio wifi off
rfkill unblock wlan
sudo iptables -F
sudo iptables -t nat -F
sudo iptables -t mangle -F
sudo iptables -X
sudo iptables -P INPUT ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo sysctl -w net.ipv4.ip_forward=1
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo iptables -t nat -L -n -v
sudo ip addr add 10.42.0.1/24 dev wlan0
sudo ip link set wlan0 up
sudo systemctl restart dnsmasq.service
sudo systemctl restart hostapd.service
sudo iptables -t nat -L -n -v
sudo iptables -L FORWARD -n -v
