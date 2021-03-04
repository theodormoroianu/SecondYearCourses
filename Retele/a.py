import socket

sock = socket.socket(socket.AF_INET,
                     socket.SOCK_DGRAM,
                     proto=socket.IPPROTO_UDP)


port = 10000
adresa="localhost"

# Tuple (address, port)
server_address=(adresa, port)

sock.bind(server_address)