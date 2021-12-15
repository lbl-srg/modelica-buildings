within Buildings.BoundaryConditions.WeatherData.BaseClasses;
impure function getLastHeaderElementTMY3
  "Gets last element from the header of a TMY3 weather data file"
  extends Modelica.Icons.Function;
 input String filNam "Name of weather data file"
 annotation (Dialog(
        loadSelector(filter="Weather files (*.mos)", caption=
            "Select weather file")));
 input String start "Start of the string that contains the elements";
 input String name "Name of data element, used in error reporting";
 output String element
    "Element at position 'pos' of the line that starts with 'start'";
protected
 String lin "Line that is used in parser";
 Integer iLin "Line number";
 Integer index =  0 "Index of string #LOCATION";
 Integer staInd "Start index used when parsing a real number";
 Integer lasInd "Next index used when parsing a real number";
 Boolean EOF "Flag, true if EOF has been reached";
algorithm
  // Get line that starts with 'start'
  iLin :=0;
  EOF :=false;
  while (not EOF) and (index == 0) loop
    iLin:=iLin + 1;
    (lin, EOF) :=Modelica.Utilities.Streams.readLine(fileName=filNam,
      lineNumber=iLin);
    index :=Modelica.Utilities.Strings.find(
      string=lin,
      searchString=start,
      startIndex=1,
      caseSensitive=false);
  end while;
  assert(not EOF, "Error: Did not find '" + start + "' when scanning the weather file."
                      + "\n   Check for correct weather file syntax.");
    // gest first and last index of the last string header element
    staInd := Modelica.Utilities.Strings.findLast(
        string=lin,
        searchString = ",",
        startIndex=0);
    lasInd := integer(Modelica.Utilities.Strings.length(lin));
  // Get the element
  element :=Modelica.Utilities.Strings.substring(lin, startIndex=staInd+1, endIndex=lasInd);
  annotation (Inline=false,
  Documentation(info="<html>
This function scans the weather data file for a line that starts with the string <pre>
start
</pre>
where <code>start</code> is a parameter.
When this line is found, the function returns the element at the position number
<code>position</code>, where <code>position</code> is a parameter.
A comma is used as the delimiter of the elements.
</html>", revisions="<html>
<ul>
<li>
December 11, 2021, by Michael Wetter:<br/>
Added <code>impure</code> declaration for MSL 4.0.0.
</li>
<li>
April 21, 2016, by Michael Wetter:<br/>
Removed call to
<a href=\"modelica://Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath\">
Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath</a>
because this function calls
<a href=\"modelica://Modelica.Utilities.Files.loadResource\">
Modelica.Utilities.Files.loadResource</a>, which needs to be resolved at compilation
time, which is difficult if it is inside a function.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/506\">Buildings, #506</a>.
</li>
<li>
September 24, 2015, by Marcus Fuchs:<br/>
Replace Dymola specific annotation by <code>loadSelector</code>
for MSL compliancy as reported by @tbeu at
<a href=\"https://github.com/RWTH-EBC/AixLib/pull/107\">RWTH-EBC/AixLib#107</a>
</li>
<li>
May 2, 2013, by Michael Wetter:<br/>
Added function call to <code>getAbsolutePath</code>.
</li>
<li>
February 25, 2012, by Michael Wetter:<br/>
Removed default value for parameter <code>name</code>.
</li>
<li>
March 5, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end getLastHeaderElementTMY3;
