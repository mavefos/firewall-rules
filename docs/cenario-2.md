# Cenário 2 — Configuração do Firewall

## Objetivo

Implementar uma segunda configuração de firewall, utilizando uma política padrão de bloqueio para o encaminhamento de pacotes e regras específicas para permitir as comunicações necessárias.

## Configurações realizadas

As regras implementadas incluem:

- Política padrão de encaminhamento com bloqueio de pacotes.
- Permissão para conexões estabelecidas e relacionadas.
- Redirecionamento das portas HTTP (80) e HTTPS (443) para o Host 1.
- Configuração de NAT com MASQUERADE.
- Permissão de acesso HTTP e HTTPS ao Host 1.
- Restrição de consultas DNS para os hosts.
- Bloqueio de acesso Telnet pelo Host 2.
- Controle de acesso SSH por endereço IP e endereço MAC.
- Liberação do serviço web do firewall pela porta 8080.
- Controle de tráfego ICMP.

## Implementação

Os comandos utilizados estão disponíveis em [`../regras/cenario-2.sh`](../regras/cenario-2.sh).

## Evidências

As capturas de tela da implementação e dos testes serão adicionadas à pasta `evidencias/cenario-2/`.
