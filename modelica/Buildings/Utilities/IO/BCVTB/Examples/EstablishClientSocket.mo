within Buildings.Utilities.IO.BCVTB.Examples;
model EstablishClientSocket
  "Example model to test establishing the client socket"
  parameter String xmlFileName = "Dummy.xml";
  parameter Integer socketFD(fixed=false)
    "Socket file descripter, or a negative value if an error occured";
initial equation
  socketFD = Buildings.Utilities.IO.BCVTB.establishClientSocket(xmlFileName=xmlFileName);
end EstablishClientSocket;
