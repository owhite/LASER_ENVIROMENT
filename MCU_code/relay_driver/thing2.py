#!/usr/bin/env python2.7

import sys
from socket import *
import time
from time import gmtime, strftime
import os

address= ( '10.0.1.14', 5000) #define server IP and port
client_socket =socket(AF_INET, SOCK_DGRAM) #Set up the Socket
client_socket.settimeout(1) #Only wait 1 second for a response

def ping_device(address, cmd):
    client_socket.sendto( cmd, address) #Send the data request
    d = {}
    d['TIME'] = strftime("%Y-%m-%d %H:%M:%S", gmtime())
    d['SOCKET'] = address

    try:
        rec_data, addr = client_socket.recvfrom(2048) 
        d['STATUS'] = 'UP'
        for i in rec_data.split('\t'):
            key, value = i.split(':', 1)
            d[key] = value

    except:
        d['STATUS'] = 'DOWN'
        pass

    return d

cmd = ""
l = len(sys.argv)
for i in range(len(sys.argv)-2,):
    cmd = cmd + sys.argv[i+1] + " "
cmd = cmd + sys.argv[l-1] + " "
cmd = cmd.rstrip()

print "::", cmd, "::"
d = ping_device(address, cmd)
print d
time.sleep(1)

print "::", cmd, "::"
d = ping_device(address, cmd)
print d
time.sleep(1)

print "::", cmd, "::"
d = ping_device(address, cmd)
print d



