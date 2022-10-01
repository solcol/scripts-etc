# based on the demo from
# http://www.ryzerobotics.com/

import socket
import sys
import time


host = ''
port = 9000
locaddr = (host,port) 


# Create a UDP socket
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

tello_address = ('192.168.10.1', 8889)

sock.bind(locaddr)

# https://dl-cdn.ryzerobotics.com/downloads/Tello/Tello SDK 2.0 User Guide.pdf

# command takeoff land flip forward back left right
# up down cw ccw speed speed?

# distances are in centimetres (forward 50 will move forward 50cm)
# rotations are in degrees (cw 90 will turn 90deg clockwise)

# directions:
# forwards = f
# backwards = b
# right = r
# left = l

def command(c):
    # log the command recieved
    print("--> %s" % c)
    # send the command to the drone
    c = c.encode(encoding="utf-8")
    sock.sendto(c, tello_address)
    # wait for a response from the drone
    data, server = sock.recvfrom(1518)
    data = data.decode(encoding="utf-8").strip()
    # log the response from the drone
    print("<-- %s" % data)

command("command")
command("battery?")
command("takeoff")
command("forward 50")
command("back 50")
command("land")

time.sleep(5)
sock.close()
