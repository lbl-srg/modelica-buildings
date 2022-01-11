within Buildings.Obsolete.Utilities.IO.Python36.Functions.BaseClasses;
impure function exchange "Function that communicates with Python"
  input String moduleName
    "Name of the python module that contains the function";
  input String functionName=moduleName "Name of the python function";
  input BaseClasses.PythonObject pytObj "Memory that holds the Python object";
  input Boolean passPythonObject
    "Set to true if the Python function returns and receives an object, see User's Guide";
  input String pythonPath "Value of PYTHONPATH environment variable";

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
                                    pythonPath,
                                    dblWri, nDblWri,
                                    dblRea, nDblRea,
                                    intWri, nIntWri,
                                    intRea, nIntRea,
                                    strWri, nStrWri,
                                    pytObj,
                                    passPythonObject)
    annotation (Library={"ModelicaBuildingsPython3.6",  "python3.6m"},
      LibraryDirectory="modelica://Buildings/Resources/Library",
      IncludeDirectory="modelica://Buildings/Resources/C-Sources",
      Include="#include \"pythonWrapper.c\"",
      __iti_dll = "ITI_ModelicaBuildingsPython3.6.dll",
      __iti_dllNoExport = true);
  annotation (Documentation(info="<html>
<p>
This function exchanges data with Python.
See
<a href=\"modelica://Buildings.Obsolete.Utilities.IO.Python36.UsersGuide\">
Buildings.Obsolete.Utilities.IO.Python36.UsersGuide</a>
for instructions, and
<a href=\"modelica://Buildings.Obsolete.Utilities.IO.Python36.Functions.Examples\">
Buildings.Obsolete.Utilities.IO.Python36.Functions.Examples</a>
for examples.
</p>
</html>", revisions="<html>
<ul>
<li>
December 11, 2021, by Michael Wetter:<br/>
Declared function as <code>impure</code> for MSL 4.0.0.
</li>
<li>
April 10, 2020, by Jianjun Hu and Michael Wetter:<br/>
Updated to Python 3.6.
</li>
<li>
March 06, 2020, by Jianjun Hu:<br/>
Upgraded python version from 2.7 to 3.6.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1760\">issue 1760</a>.
</li>
<li>
April 13, 2018, by Michael Wetter:<br/>
Corrected <code>LibraryDirectory</code> annotation.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1160\">issue 1160</a>.
</li>
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
