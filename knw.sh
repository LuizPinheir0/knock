#!/bin/bash

# Verifica se a rede alvo foi informada
if [ -z "$1" ]; then
    echo "Informe a rede alvo, exemplo: 192.168.0"
    exit 1
fi

# Verifica se o script está sendo executado como root
if [ "$UID" -ne 0 ]; then
    echo "Execute como root, exemplo: sudo $0 192.168.0"
    exit 1
fi

# Inicia o loop
echo "## Iniciando testes, aguarde..."
for ip in {1..254}; do
    echo "##> Testando IP $1.$ip"
    hping3 "$1.$ip" -S -c 1 -p 13 &> /dev/null
    hping3 "$1.$ip" -S -c 1 -p 37 &> /dev/null
    hping3 "$1.$ip" -S -c 1 -p 30000 &> /dev/null
    hping3 "$1.$ip" -S -c 1 -p 3000 &> /dev/null

    curl "http://$1.$ip:1337" -m 0.5 2>/dev/null
done
