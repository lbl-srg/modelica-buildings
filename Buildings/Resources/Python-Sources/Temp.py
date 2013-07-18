'''
GeneralCalBayComm.py

Allows user to specify login, pw and command. Then sends signal to CalBay adapter

Created Jul 12, 2013

@author: Peter Grant

'''

def CalBayComm(Login, Password, Command):

    #Login = 'P Grant'
    #Password = 'pgrant213'
    #Command = 'GetDAQ:WattStopper.HS1--4126F--Light Level-1'

    conn = FlexlabExtInterface()
    print "Opening connection.\n"
    print "Sending command 'LOGIN:Philips 1:Philips 1':\n" + conn.open("128.3.20.130",3500,Login,Password)
    
    SendString = ":".join([Command,Login,Password])
    print "Checking light levels in office 4126F"
    print "Sending command to read WattStopper.HS1--4126F--Light Level-1:\n'GETDAQ:WattStopper.HS1--4126F--Relay-3:P Grant:pgrant213':\n"
    res = conn.cmd(SendString)
    print "Result: "+str(res)
    conn.close()
    print res
    return res


Output = CalBayComm('P Grant', 'pgrant213', 'GetDAQ:WattStopper.HS1--4126F--Light Level-1')

print Output


