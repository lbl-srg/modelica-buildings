within Buildings.Utilities.IO.BCVTB.BaseClasses;
function establishClientSocket "Establishes the client socket connection"

annotation(Documentation(info="<html>
Function that establishes a socket connection to the BCVTB.
<p>
For the xml file name, on Windows use two backslashes to separate directories, i.e., use
<pre>
  xmlFileName=\"C:\\\\examples\\\\roomPtDymola\\\\socket.cfg\"
</pre>
In case of a problem, check the file <tt>utilSocket.log</tt> that is written during
the data exchange with the BCVTB.
</html>",
revisions="<html>
<ul>
<li>
May 5, 2009, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  input String xmlFileName = "socket.cfg"
    "Name of xml file that contains the socket information";
  output Integer socketFD
    "Socket file descripter, or a negative value if an error occured";
  external "C" 
     socketFD=establishBSDSocket(xmlFileName) 
       annotation(Library="bcvtb_modelica",
                  Include="#include \"bcvtb.h\"");
end establishClientSocket;
