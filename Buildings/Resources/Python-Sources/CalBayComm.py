'''
GeneralCalBayComm.py

Communicates with CalBay adapter to control lights

This script was written to interface with a simulation program. The simulation program sends a dimming light control signal,
then CalBay communicates with the lights to send the control signal. The script then reads the light level in the space, and
sends that information back to the simulation program.

Created Jul 12, 2013

@author: Peter Grant

'''

import socket # Use the Python socket library to do TCP socket communications.
import time
import struct

CMDSLEEP = 0.10 # time in seconds to wait after sending command to read command.
RECVSIZE = 6553600  # number of bytes to read on recv after command.

#This portion of the code establishes communication with the CalBay adapter. It was written by Matt Whitlock

class SocketClient(object):
    '''
    SocketClient class provides high-level Ethernet socket communications,
        via a small wrapper around the Python standard socket class.
    
    Can be used as basis for all TCP socket communications
    '''
    def __init__(self):
        '''
        Constructor
        
        @param target: Target IP address or hostname
        @param port: TCP port to use
        '''
        self.sk = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        #self.open(target, port)
    def open(self, target, port):
        '''
        Open connection to target
        
        @param target: Target IP address or hostname
        @param port: TCP port to use
        '''
        try:
            result = self.sk.connect((target, port))
        except socket.error as X:
            return 'Failure - connection could not be established.\r' + result + X
        else:
            return 'Success'
    def close(self):
        '''
        Clean up references
        '''
        return self.sk.close()
    def cmd(self, command):
        '''
        Send command to target and read response
        
        Assumes that TCP commands sent are echoed back.
        '''
        # use sendall() to block until whole command is sent.
        cmdlen = len(command) 
        self.sk.sendall(command)
        time.sleep(CMDSLEEP)
        r = self.sk.recv(RECVSIZE)
        return r[cmdlen:]
    
class FlexlabExtInterface(SocketClient):    
    '''
    Class to provide interface to Flexlab External TCP Interface.

    @param target: Target IP address or hostname
    @param port: TCP port to use
    @param pwd: (Optional) password for the WiFly device.

    '''

    def open(self, target, port, user = 'user', pwd = 'nopass'):
        # Could have comms problems either when opening port for the first time
        #   due to timeout or unavailable communications.
        try:
            #self.sk.settimeout(4)
            self.sk.settimeout(15)
            self.sk.connect((target, port))
        except socket.timeout:
            # occurs if not on the network and timeout is < 25
            resp = 'Failure - connection could not be established due to timeout.\r'
            resp += 'Please ensure that you can connect to the device.\r'
            return resp
        except socket.error as X:
            # occurs if not on network and timeout >= 25 
            return 'Failure - connection could not be established.\r' + str(X)
        else:
            # Connected; proceeed.
            
            # Always check user auth on open.
            try:
                #self.sk.send(' ' + user + pwd)
                resp = self.cmd('LOGIN:' + user + ':' + pwd)
            except socket.timeout as X:
                # occurs if not on the network and timeout is < 25
                return 'Failure - connection could not be established due to timeout.\r'
            except socket.error as X:
                # occurs if not on network and timeout >= 25 
                resp = 'Failure - connection could not be established.\r' + str(X)
                return resp
            else:
                # wait longer for device to respond.
                #time.sleep(CMDSLEEP * 2.5)  
                #resp = self.sk.recv(RECVSIZE)
                return ('Success:\n' + resp)

    def cmd(self, command):
        '''
        Send command to external interface and read response
        
        @param command: ASCII command to send to the central workstation.
        '''
        packed_len = struct.pack('>L', len(command))
        self.sk.sendall(packed_len + command)
        time.sleep(CMDSLEEP) # slowed this down from .05 in order to clean up errors in stress testing.
        r = self.sk.recv(RECVSIZE)
        # strip off command and \r\n
        #return r[cmdlen+2:]
        return r[4:]

#The function CalBayComm(u) communicates with the CalBay adapter.
#u is an input sent to the script from a simulation program.
#In this version of the script u represents a setpoint for the 
#dimming control on the lights in office 4126F.
#The output from this function is the current light level in 4126F.
#The light level is read from the CalBay adapter at the end of the function.
def CalBayComm(u):

    #References the FlexlabExtInterface() function to communicate with the CalBay adapter whenever "conn" is called
    conn = FlexlabExtInterface()

    #Opens connection to the CalBay adapter. There are four elements in the function call
    #1. The IP address of the adapter
    #2. The desired port for communication
    #3. The login of the person running the script
    #4. The password of the person running the script
    #"Login" and "Password" are currently used as placeholders for a user's credentials. They must be edited by the user before the script can be used. 
    conn.open("128.3.20.130",3500,"Login","Password")
    
    #Sends the dimming control signal to the CalBay adapter. There are seven elements in the string sent to CalBay.
    #1. SETDAQ - This command indicates that the string is sending a control signal, and will manipulate some aspect of how the building is controlled.
    #2. WattStopper.HS1 - This portion of the string indicates which server the desired control point is stored on.
    #3. --4126F - This portion of the string indicates that the control point is in office 4126F
    #4. --Dimmer Level-2 - This portion of the string indicates that the desired control point is light dimmer #2. Note: Dimmer Level-1 and 
    #Dimmer Level-3 seem to have no effect
    #5 str(u) - This portion converts the dimmer set point (u), taken from a simulation program, into a string and includes it in the send string
    #6 Login - The user's login. This must be replaced with an actual credential before using the script
    #7 Password - The user's password. This must be replaced with an actual credential before using the script
    conn.cmd('SETDAQ:WattStopper.HS1--4126F--Dimmer Level-2:' + str(u) + ':Login:Password') 

    time.sleep(30)
    
    #Sends the light level read string to the CalBay adapter. Most elements are the same as the send string, and only the changing elements are described here.
    #1. GETDAQ - This command indicates that the string is obtaining a sensor reading from the CalBay adapter.
    #2. Light Level-1 - Indicates that the sensor to read is the light level.
    #3. float( - The value read from conn.cmd is a string. "float(" converts it to a float value
    y = float(conn.cmd('GetDAQ:WattStopper.HS1--4126F--Light Level-1:Login:Password'))

    #Creates a results array for output from the function. Returns the light level (y) and the dimmer level set point (u)
    res = []
    res.append(y)
    res.append(u)

    return res

