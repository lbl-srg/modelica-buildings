function printRealArray "Print string to terminal or file" 
  extends Modelica.Icons.Function;
  input Real[:] x "Input to be printed";
  input String fileName="" "File where to print (empty string is the terminal)";
  output String outStr="" "String to be printed";
algorithm 
  for i in 1:size(x,1) loop
     outStr :=outStr + "  " + realString(number=  x[i], minimumWidth=  8, precision=  8);
  end for;
  Modelica.Utilities.Streams.print(string=outStr, fileName=fileName);
  annotation (Documentation(revisions="<html>
<ul>
<li>
September 20, 2007 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Function that prints a real array to an output file.
</p>
</html>"));
end printRealArray;
