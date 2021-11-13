import argparse
import random
import time
import itertools
from time import sleep
import re ## para expresiones regulares

from pythonosc import osc_message_builder
from pythonosc import udp_client

#argumentos para OSC
if __name__ == "__main__":
  parser = argparse.ArgumentParser()
  parser.add_argument("--ip", default="127.0.0.1",
      help="The ip of the OSC server")
  parser.add_argument("--port", type=str, default=57120,
      help="The port the OSC server is listening on")
  args = parser.parse_args()

  client = udp_client.SimpleUDPClient(args.ip, args.port)

  ##una palabra por linea del txt
  def leerpalabras(partitura):
    palabra = itertools.groupby(
        itertools.takewhile(lambda c:bool(c),
            map(partitura.read,
                itertools.repeat(1))), str.isspace)

    return("".join(group) for pred, group in palabra if not pred)

## el texto que estoy abriendo se llama partitura0 y es un txr, change to convenience!! 
  with open("partitura0.txt", "r") as f:
      c = 0
      for palabra in leerpalabras(f):
          pat= re.compile(r'^[^aeiouAEIOUáéíóúàèìòù]') 
          patr = re.compile(r'^[^bcdfghjklmnñpqrstvwxyzBCDFGHJKLMNÑOPQRSTVWXYZ]')
          p = 0
          if c < 30:
              lon = 0.6
          elif c < 60:
              lon = 0.15
          elif c < 90:
              lon = 0.3
          else:
              lon = 0.6
          if re.match(pat, palabra):
              p = 1
          elif re.match(patr, palabra):
              p = 2
          else:
              p = 3
          client.send_message("/supercollider", p)
          c = c + 1
          print(palabra)
          time.sleep(lon)
