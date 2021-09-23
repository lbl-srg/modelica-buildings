within Buildings.Experimental.DHC.Loads.BaseClasses;
function getPeakLoad
  "Function that reads the peak load from the load profile"
  input String string
    "String that is written before the '=' sign";
  input String filNam
    "Name of data file with heating and cooling load"
    annotation (Dialog(loadSelector(filter="Load file (*.mos)",caption="Select load file")));
  output Real number
    "Number that is read from the file";
protected
  String lin
    "Line that is used in parser";
  Integer iLin
    "Line number";
  Integer index=0
    "Index of string 'string'";
  Integer staInd
    "Start index used when parsing a real number";
  Integer nexInd
    "Next index used when parsing a real number";
  Boolean found
    "Flag, true if 'string' has been found";
  Boolean EOF
    "Flag, true if EOF has been reached";
  String del
    "Found delimiter";
algorithm
  // Get line that contains 'string'
  iLin := 0;
  EOF := false;
  while(not EOF) and(index == 0) loop
    iLin := iLin+1;
    (lin,EOF) := Modelica.Utilities.Streams.readLine(
      fileName=filNam,
      lineNumber=iLin);
    index := Modelica.Utilities.Strings.find(
      string=lin,
      searchString=string,
      startIndex=1,
      caseSensitive=true);
  end while;
  assert(
    not EOF,
    "Error: Did not find '"+string+"' when scanning '"+filNam+"'."+"\n   Check for correct file syntax.");
  // Search for the equality sign
  (del,nexInd) := Modelica.Utilities.Strings.scanDelimiter(
    string=lin,
    startIndex=Modelica.Utilities.Strings.length(string)+1,
    requiredDelimiters={"="},
    message="Failed to find '=' when reading peak load in '"+filNam+"'.");
  // Read the value behind it.
  number := Modelica.Utilities.Strings.scanReal(
    string=lin,
    startIndex=nexInd,
    message="Failed to read double value when reading peak load in '"+filNam+"'.");
  annotation (
    Documentation(
      info="<html>
<p>
Function that reads a double value from a text file.
</p>
<p>
This function scans a file that has a format such as
</p>
<pre>
#1
#Some other text
#Peak space cooling load = -383165.6989 Watts
#Peak space heating load = 893931.4335 Watts
double tab1(8760,4)
0,0,5972.314925,16
3600,0,4925.839944,1750.915684
...
</pre>
<p>
The parameter <code>string</code> is a string that the function
searches for, starting at the first line.
If it finds the string, it expects an equality sign, and
returns the double value after this equality sign.
If the function encounters the end of the file, it
terminates the simulation with an assertion.
</p>
<p>
See
<a href=\"modelica://Buildings.Experimental.DHC.Loads.BaseClasses.Validation.GetPeakLoad\">
Buildings.Experimental.DHC.Loads.BaseClasses.Validation.GetPeakLoad</a>
for how to invoke this function.
</p>
</html>",
      revisions="<html>
<ul>
<li>
December 1, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end getPeakLoad;
