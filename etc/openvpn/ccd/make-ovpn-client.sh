#!/bin/bash
 
# Generate OpenVPN clients configuration files.
 
CLIENT_NAME=$1
OPENVPN_SERVER="192.168.1.237"
CA_DIR=/etc/openvpn/openvpn-ca
CLIENT_DIR=/etc/openvpn/ccd
 
cd ${CA_DIR}
source vars
./build-key ${CLIENT_NAME}
 
echo "client
dev tun
proto udp4
remote ${OPENVPN_SERVER} 53
user nobody
group nogroup
persist-key
persist-tun
cipher AES-256-CBC
auth SHA256
key-direction 1
remote-cert-tls server
comp-lzo
verb 4" > ${CLIENT_DIR}/${CLIENT_NAME}.ovpn
 
cat <(echo -e '<ca>') \
    ${CA_DIR}/keys/ca.crt \
    <(echo -e '</ca>\n<cert>') \
    ${CA_DIR}/keys/${CLIENT_NAME}.crt \
    <(echo -e '</cert>\n<key>') \
    ${CA_DIR}/keys/${CLIENT_NAME}.key \
    <(echo -e '</key>\n<tls-auth>') \
    ${CA_DIR}/keys/ta.key \
    <(echo -e '</tls-auth>') \
    >> ${CLIENT_DIR}/${CLIENT_NAME}.ovpn
 
echo -e "Client File Created - ${CLIENT_DIR}/${CLIENT_NAME}.ovpn"