NOM=rproxy    # web-dmz | rproxy | bastion
IP=192.168.10.11      # .10 web-dmz | .11 rproxy | .20 bastion
IFACE=enp0s3           # nom de ta carte reseau

hostnamectl set-hostname $NOM
sed -i "s/^127.0.1.1.*/127.0.1.1\t$NOM/" /etc/hosts
cp /etc/network/interfaces /etc/network/interfaces.bak
cat > /etc/network/interfaces <<EOF
source /etc/network/interfaces.d/*

auto lo
iface lo inet loopback

auto $IFACE
iface $IFACE inet static
    address $IP/24
    gateway 192.168.10.1
    up ip route replace 192.168.20.0/24 via 192.168.10.254
    up ip route replace 192.168.30.0/24 via 192.168.10.254
EOF
systemctl restart networking
ip -br addr; ip route
