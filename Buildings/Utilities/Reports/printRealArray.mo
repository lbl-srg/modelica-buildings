within Buildings.Utilities.Reports;
function printRealArray "Print string to terminal or file"
  extends Modelica.Icons.Function;
  input Real[:] x "Input to be printed";
  input String fileName="" "File where to print (empty string is the terminal)";
  input Integer minimumLength =  1 "Minimum width of result";
  input Integer significantDigits = 6 "Number of significant digits";
  output String outStr="" "String to be printed";
algorithm
  for i in 1:size(x,1) loop
     outStr :=outStr + "  "
                     + String(x[i],
                              minimumLength=minimumLength,
                              significantDigits=significantDigits);
  end for;
  Modelica.Utilities.Streams.print(string=outStr, fileName=fileName);
  annotation (Documentation(info="<html>
<p>
Function that prints a real array to an output file.
</p>
</html>",
revisions="<html>
<ul>
<li>
August 16, 2011 by Michael Wetter:<br/>
Removed <code>number</code> attribute in <code>String</code>
function as this is not according to the Modelica specification.
</li>
<li>
May 27, 2011 by Michael Wetter:<br/>
Changed parameter <code>precision</code> to <code>significantDigits</code>
and <code>minimumWidth</code> to <code>minimumLength</code> to use the same
terminology as the Modelica Standard Library.
</li>
<li>
October 1, 2008 by Michael Wetter:<br/>
Revised implementation and moved to new package.
</li>
<li>
September 20, 2007 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end printRealArray;
