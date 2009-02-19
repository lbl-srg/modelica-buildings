within Buildings.Utilities.IO.BCVTB;
function establishClientSocket
  "Establishes the client for the socket connection"

  annotation (
     Include="#include <utilSocket.h>",
     Library={"bcvtb.lib"});
  input String xmlFileName = "Dummy.xml";
  output Integer socketFD
    "Socket file descripter, or a negative value if an error occured";
  external "C" 
     socketFD=establishclientsocket(xmlFileName) 
       annotation(Library="P:\bcvtb\task1-supVis\code\bcvtb\trunk\bcvtb\lib\util\bcvtb.lib",
                  Include="#include \"utilSocket.h\"");

end establishClientSocket;
