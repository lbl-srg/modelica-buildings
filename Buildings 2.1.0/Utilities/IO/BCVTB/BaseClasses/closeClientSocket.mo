within Buildings.Utilities.IO.BCVTB.BaseClasses;
function closeClientSocket
  "Closes the socket for the inter process communication"

  input Integer socketFD
    "Socket file descripter, or a negative value if an error occurred";
  output Integer retVal
    "Return value of the function that closes the socket connection";
  external "C"
     retVal=closeModelicaClient(socketFD)
       annotation(Library="bcvtb_modelica",
                  Include="#include \"bcvtb.h\"");
annotation(Documentation(info="<html>
Function that closes the inter-process communication.
</html>",
revisions="<html>
<ul>
<li>
May 5, 2009, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end closeClientSocket;
