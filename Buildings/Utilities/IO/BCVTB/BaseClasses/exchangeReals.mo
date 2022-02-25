within Buildings.Utilities.IO.BCVTB.BaseClasses;
function exchangeReals "Exchanges values of type Real with the socket"

  input Integer socketFD(min=1) "Socket file descripter";
  input Integer flaWri "Communication flag to write to the socket stream";
  input Modelica.Units.SI.Time simTimWri
    "Current simulation time in seconds to write";
  input Real[nDblWri] dblValWri "Double values to write";
  input Integer nDblWri "Number of double values to write";
  input Integer nDblRea "Number of double values to read";
  output Integer flaRea "Communication flag read from the socket stream";
  output Modelica.Units.SI.Time simTimRea
    "Current simulation time in seconds read from socket";
  output Real[nDblRea] dblValRea "Double values read from socket";
  output Integer retVal "The exit value, which is negative if an error occurred";
  external "C"
     retVal=exchangeModelicaClient(socketFD,
       flaWri, flaRea,
       simTimWri,
       dblValWri, nDblWri,
       simTimRea,
       dblValRea, nDblRea)
    annotation(Library="bcvtb_modelica",
        Include="#include \"bcvtb.h\"");
annotation(Documentation(info="<html>
Function to exchange data of type <code>Real</code> with the socket.
This function must only be called once in each
communication interval.
</html>",
revisions="<html>
<ul>
<li>
May 5, 2009, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end exchangeReals;
