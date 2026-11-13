#!/bin/bash

# Cenario 2 - Politica restritiva de encaminhamento
# Projeto academico de Ciberseguranca

# Limpeza das regras anteriores
iptables -F

# Politicas padrao
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD DROP

# Permite conexoes estabelecidas
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Redirecionamento HTTP e HTTPS
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j DNAT --to-destination 172.31.1.1:80
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 443 -j DNAT --to-destination 172.31.1.1:443
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

# Permite novas conexoes com HOST1
iptables -A FORWARD -d 172.31.1.1 -p tcp -m multiport --dports 80,443 -m state --state NEW -j ACCEPT

# HOST1 - DNS e navegacao HTTP/HTTPS
iptables -A FORWARD -s 172.31.1.1 -d 192.168.122.3 -p udp --dport 53 -m state --state NEW -j ACCEPT
iptables -A FORWARD -s 172.31.1.1 -d 192.168.122.3 -p tcp --dport 53 -m state --state NEW -j ACCEPT
iptables -A FORWARD -s 172.31.1.1 -p tcp -m multiport --dports 80,443 -m state --state NEW -j ACCEPT

# HOST2 - Permite somente DNS para o servidor especificado
iptables -A FORWARD -s 172.31.1.2 -d 192.168.122.3 -p udp --dport 53 -m state --state NEW -j ACCEPT

# HOST2 - Bloqueia Telnet e permite outros servicos TCP
iptables -A FORWARD -s 172.31.1.2 -p tcp ! --dport 23 -m state --state NEW -j ACCEPT

# Acesso SSH por IP e MAC
iptables -A INPUT -i eth1 -s 172.31.1.2 -p tcp --dport 22 -m mac --mac-source 02:42:13:39:56:00 -j ACCEPT
iptables -A INPUT -i eth0 -s 192.168.122.3 -p tcp --dport 22 -m mac --mac-source 02:42:09:c5:68:00 -j ACCEPT

# Firewall como servidor web na porta 8080
iptables -A INPUT -i eth1 -p tcp --dport 8080 -j ACCEPT

# Firewall - DNS, HTTP e HTTPS de saida
iptables -A OUTPUT -o eth0 -p udp --dport 53 -m state --state NEW -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp -m multiport --dports 80,443 -m state --state NEW -j ACCEPT

# ICMP - Ping permitido somente pela LAN1
iptables -A INPUT -i eth1 -p icmp --icmp-type echo-request -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP

# Outros tipos de ICMP
iptables -A INPUT -p icmp -j ACCEPT
iptables -A OUTPUT -p icmp -j ACCEPT
iptables -A FORWARD -p icmp -j ACCEPT

# Bloqueio final
iptables -A INPUT -j DROP
iptables -A OUTPUT -j DROP
