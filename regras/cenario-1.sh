#!/bin/bash

# Cenario 1 - Controle de acesso e filtragem
# Projeto academico de Ciberseguranca

# Limpeza das regras anteriores
iptables -F

# Politicas padrao
iptables -P INPUT DROP
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT

# Permite conexoes estabelecidas
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Restricao de DNS
iptables -A FORWARD -s 172.31.1.1 -p udp --dport 53 ! -d 192.168.122.3 -j DROP
iptables -A FORWARD -s 172.31.1.1 -p tcp --dport 53 ! -d 192.168.122.3 -j DROP

# Redirecionamento HTTP e HTTPS
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j DNAT --to 172.31.1.1:80
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 443 -j DNAT --to 172.31.1.1:443
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

# HOST1 - Permite DNS, HTTP e HTTPS
iptables -A FORWARD -s 172.31.1.1 -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -s 172.31.1.1 -p udp --dport 53 -j ACCEPT
iptables -A FORWARD -s 172.31.1.1 -p tcp -m multiport --dports 80,443 -j ACCEPT

# HOST2 - Bloqueia novas conexoes de entrada
iptables -A FORWARD -d 172.31.1.2 -m state --state NEW -j DROP

# HOST2 - Bloqueia Telnet
iptables -A FORWARD -s 172.31.1.2 -p tcp --dport 23 -j DROP

# HOST2 - Permite somente DNS em UDP
iptables -A FORWARD -s 172.31.1.2 -p udp ! --dport 53 -j DROP

# Acesso SSH por IP e MAC
iptables -A INPUT -i eth1 -s 172.31.1.2 -p tcp --dport 22 -m mac --mac-source 02:42:13:39:56:00 -j ACCEPT
iptables -A INPUT -i eth0 -s 192.168.122.3 -p tcp --dport 22 -m mac --mac-source 02:42:09:c5:68:00 -j ACCEPT

# Firewall como servidor web na porta 8080
iptables -A INPUT -i eth1 -p tcp --dport 8080 -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Firewall - Restricao de saida HTTP, HTTPS e DNS pela eth0
iptables -A OUTPUT -o eth0 -m state --state NEW -p tcp --dport 80 -j DROP
iptables -A OUTPUT -o eth0 -m state --state NEW -p tcp --dport 443 -j DROP
iptables -A OUTPUT -o eth0 -m state --state NEW -p udp --dport 53 -j DROP
iptables -A OUTPUT -o eth0 -m state --state NEW -p tcp --dport 53 -j DROP

# ICMP - Ping permitido somente pela LAN1
iptables -A INPUT -i eth1 -p icmp --icmp-type echo-request -j ACCEPT
iptables -A INPUT -p icmp ! --icmp-type echo-request -j ACCEPT
iptables -A OUTPUT -p icmp -j ACCEPT
iptables -A FORWARD -p icmp -j ACCEPT

# Bloqueio final
iptables -A INPUT -j DROP
iptables -A OUTPUT -j DROP
