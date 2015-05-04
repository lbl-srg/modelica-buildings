''' GeneralCalBayComm.py

    Script that communicates with CalBay adapter to control lights.

    This script was written to interface with a simulation program.
    Input to the script is a dimming light control signal, which
    CalBay sends to the lights.
    Next, the script reads from CalBay the light level in the space, and
    sends that information back to the simulation program.

    This script is not yet finalized because the application programming
    interface for data exchange with the CalBay adaptor of FLEXLAB has
    not yet been finalized.
    The script works, however, with the CalBay infrastructure as of
    October 2013.

'''

import socket # Use the Python socket library to do TCP socket communications.
import time
import struct

CMDSLEEP = 0.10 # time in seconds to wait after sending command to read command.
RECVSIZE = 6553600  # number of bytes to read on recv after command.

#This portion of the code establishes communication with the CalBay adapter. It was written by Matt Whitlock

class SocketClient():
    ''' SocketClient class provides high-level Ethernet socket communications.

        It be used as basis for all TCP socket communications.
    '''

    def __init__(self):
        ''' Constructor

        '''
        self.sc = socket.socket(socket.AF_INET, socket.SOCK_STREAM)


    def open(self, target, port):
        ''' Open connection to target

        :param target: Target IP address or hostname
        :param port: TCP port to use

        '''
        try:
            result = self.sc.connect((target, port))
        except socket.error as X:
            return 'Error: Connection could not be established.\r' + result + X
        else:
            return 'Success'

    def close(self):
        ''' Close the socket connection.
        '''
        return self.sc.close()

    def cmd(self, command):
        ''' Send command to target and read response.

            Assumes that TCP commands sent are echoed back.

            :param command: The command to be sent to the socket.

        '''
        # use sendall() to block until whole command is sent.
        cmdlen = len(command)
        self.sc.sendall(command)
        time.sleep(CMDSLEEP)
        r = self.sc.recv(RECVSIZE)
        return r[cmdlen:]


class FLEXLABInterface(SocketClient):
    ''' Class to provide interface to FLEXLAB External TCP Interface.

    '''

    def open(self, target, port, user = 'user', pwd = 'nopass'):
        ''' Open the socket connection.

        :param target: Target IP address or hostname
        :param port: TCP port to use.
        :param user: Optional user name.
        :param pwd: Optional password.

        '''

        # Could have comms problems either when opening port for the first time
        #   due to timeout or unavailable communications.
        try:
            self.sc.settimeout(15)
            self.sc.connect((target, port))
        except socket.timeout as e:
            # occurs if not on the network and timeout is < 25
            r = str(e) + '\n'
            r += 'Error: Socket connection could not be established due to timeout.\n'
            r += '       Please ensure that you can connect to the device.'
            raise socket.timeout(r)
        except socket.error as e:
            # occurs if not on network and timeout >= 25
            r = str(e) + '\n'
            r += "Error: Connection could not be established."
            raise socket.error(r)
        else:
            # Connected; proceeed.

            # Always check user auth on open.
            try:
                resp = self.cmd('LOGIN:' + user + ':' + pwd)
            except socket.timeout as e:
                # occurs if not on the network and timeout is < 25
                r = str(e) + '\n'
                r += "Error: Connection could not be established due to timeout."
                raise socket.timeout(r)
            except socket.error as e:
                # occurs if not on network and timeout >= 25
                r = str(e) + '\n'
                r += "Error: Connection could not be established."
                raise socket.error(r)
            else:
                return ('Success:\n' + resp)

    def cmd(self, command):
        ''' Send command to external interface and return a string that contains the response.

        :param command: ASCII command to send to the central workstation.

        '''
        packed_len = struct.pack('>L', len(command))
        self.sc.sendall(packed_len + command)
        time.sleep(CMDSLEEP) # slowed this down from .05 in order to clean up errors in stress testing.
        r = self.sc.recv(RECVSIZE)
        # strip off command
        return r[4:]

def CalBayComm(u):
    ''' Send the signal u to the CalBay adapter, and return a list that contains
        `u` and `y`, where `y` is the measured illuminance level.

        :param u: input signal for the light control

        In this example, u represents a setpoint for the
        dimming control on the lights in the office 4126F.
        The output from this function is the current light level in 4126F.
        The light level is read from the CalBay adapter.

        This function uses commands SETDAQ and GetDAQ.
        Several other commands are available. The ones that are most useful are likely to be:

         * "REQCHAN:(USER):(PASS)"
           This command returns all of the communication channels available to the user.
         * "GETDAQ:(SYS.CHAN):(USER):(PASS)"
           This command reads a value from the requested channel.
         * "SETDAQ:(SYS.CHAN):(VALUE):(USER):(PASS)"
           This command sets a control point to the value specified by the user.

     '''

    #Make an instance of the FLEXLAB interface
    conn = FLEXLABInterface()

    # Open the connection to the CalBay adapter. There are four elements in the function call
    # 1. The IP address of the adapter
    # 2. The desired port for communication
    # 3. The login of the person running the script
    # 4. The password of the person running the script
    # "Login" and "Password" are currently used as placeholders for a user's credentials.
    # They must be edited by the user before the script can be used.
    conn.open("128.3.20.130",3500,"Login","Password")

    #Sends the dimming control signal to the CalBay adapter. There are seven elements in the string sent to CalBay.
    #1. SETDAQ - This command indicates that the string is sending a control signal,
    #            and will manipulate some aspect of how the building is controlled.
    #2. WattStopper.HS1 - This portion of the string indicates which server the desired control point is stored on.
    #3. --4126F - This portion of the string indicates that the control point is in office 4126F
    #4. --Dimmer Level-2 - This portion of the string indicates that the desired control point
    #   is light dimmer #2. Note: Dimmer Level-1 and
    #Dimmer Level-3 seem to have no effect
    #5 str(u) - This portion converts the dimmer set point (u) to a string.
    #6 Login - The user's login. This must be replaced with an actual credential before using the script
    #7 Password - The user's password. This must be replaced with an actual credential before using the script
    conn.cmd('SETDAQ:WattStopper.HS1--4126F--Dimmer Level-2:' + str(u) + ':Login:Password')

    # Sleep for 30 seconds. In actual lighting control, this should be reduced to fractions of a second.
    # A cleaner implementation would implement the real-time synchronization in the program that
    # calls this function
    time.sleep(30)

    # Sends the light level read string to the CalBay adapter.
    # Most elements are the same as the send string, and only the changing elements are described here.
    # 1. GETDAQ - This command indicates that the string is obtaining a sensor reading from the CalBay adapter.
    # 2. Light Level-1 - Indicates that the sensor to read is the light level.

    retStr = conn.cmd('GetDAQ:WattStopper.HS1--4126F--Light Level-1:Login:Password')

    # Error handling
    if "USER AUTHENTICATION ERROR" in retStr:
        raise RuntimeError(retStr)

    # Convert return value to float
    y = float(retStr)

    # Create a results array for output from the function.
    # Returns the light level (y) and the dimmer level set point (u)
    res = []
    res.append(y)
    res.append(u)

    return res
