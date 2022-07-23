from pythonosc import udp_client
import time

client = udp_client.SimpleUDPClient("127.0.0.1", 57120) #default ip and port for SC
client.send_message("/print", 440) # set the frequency at 440

f = 440
while True:
  f = f + f/100.0
  client.send_message('/key0', f) # set the frequency at 440
  client.send_message('/key1', f/2.0) # set the frequency at 440
  client.send_message('/key2', f*2.0) # set the frequency at 440
  break
  time.sleep(100.0)
