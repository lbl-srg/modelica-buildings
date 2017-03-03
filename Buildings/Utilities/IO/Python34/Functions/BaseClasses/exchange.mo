within Buildings.Utilities.IO.Python34.Functions.BaseClasses;
function exchange "Function that communicates with Python"
  input String moduleName
    "Name of the python module that contains the function";
  input String functionName=moduleName "Name of the python function";

  input Real    dblWri[max(1, nDblWri)] "Double values to write";
  input Integer intWri[max(1, nIntWri)] "Integer values to write";
  input String  strWri[max(1, nStrWri)] "String values to write";

  input Integer nDblWri(min=0) "Number of double values to write";
  input Integer nDblRea(min=0) "Number of double values to read";

  input Integer nIntWri(min=0) "Number of integer values to write";
  input Integer nIntRea(min=0) "Number of integer values to read";

  input Integer nStrWri(min=0) "Number of strings to write";
//  input Integer nStrRea(min=0) "Number of strings to read";
//  input Integer strLenRea(min=0)
//    "Maximum length of each string that is read. If exceeded, the simulation stops with an error";

  output Real    dblRea[max(1, nDblRea)] "Double values returned by Python";
  output Integer intRea[max(1, nIntRea)] "Integer values returned by Python";

  external "C" pythonExchangeValues(moduleName, functionName,
                                    dblWri, nDblWri,
                                    dblRea, nDblRea,
                                    intWri, nIntWri,
                                    intRea, nIntRea,
                                    strWri, nStrWri)
    annotation (Library={"ModelicaBuildingsPython3.4",  "python3.4"},
      LibraryDirectory={"modelica://Buildings/Resources/Library"},
      IncludeDirectory="modelica://Buildings/Resources/C-Sources",
      Include="#include \"python34Wrapper.c\"");

  annotation (Documentation(info="<html>
<p>
This function exchanges data with Python.
See
<a href=\"modelica://Buildings.Utilities.IO.Python34.UsersGuide\">
Buildings.Utilities.IO.Python34.UsersGuide</a>
for instructions, and
<a href=\"modelica://Buildings.Utilities.IO.Python34.Functions.Examples\">
Buildings.Utilities.IO.Python34.Functions.Examples</a>
for examples.
</p>
</html>", revisions="<html>
<ul>
<li>
March 27, 2013, by Thierry S. Nouidui:<br/>
Added  a wrapper to <code>ModelicaFormatError</code> to support Windows OS.
</li>
<li>
January 31, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end exchange;
