# Cenário 1 — Configuração do Firewall

## Objetivo

Implementar regras de firewall para controlar a comunicação entre as máquinas da rede, restringindo o acesso a determinados serviços e permitindo apenas os tipos de tráfego definidos no cenário da atividade.

## Configurações realizadas

As regras implementadas incluem:

- Política padrão de entrada com bloqueio de pacotes.
- Permissão para tráfego de saída e encaminhamento conforme as regras configuradas.
- Restrição de consultas DNS.
- Redirecionamento das portas HTTP (80) e HTTPS (443) para o Host 1.
- Configuração de NAT com MASQUERADE.
- Restrição de acesso do Host 2 a determinados serviços.
- Controle de acesso SSH por endereço IP e endereço MAC.
- Liberação de acesso ao servidor web do firewall pela porta 8080.
- Controle de tráfego ICMP.

## Implementação

Os comandos utilizados estão disponíveis em [`../regras/cenario-1.sh`](../regras/cenario-1.sh).

## Evidências

As capturas de tela da implementação e dos testes serão adicionadas à pasta `evidencias/cenario-1/`.
