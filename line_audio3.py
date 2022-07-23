from pythonosc import udp_client
import time

client = udp_client.SimpleUDPClient("127.0.0.1", 57120) #default ip and port for SC
client.send_message("/print", 440) # set the frequency at 440

f = 440
while True:
  f = f + f/100.0
  client.send_message("/print", f) # set the frequency at 440
  time.sleep(0.05)
