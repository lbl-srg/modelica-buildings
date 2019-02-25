within Buildings.Utilities.IO.Python27.Functions;
function exchange "Function that communicates with Python"
  input String moduleName
    "Name of the python module that contains the function";
  input String functionName=moduleName "Name of the python function";
  input BaseClasses.PythonObject pytObj "Memory that holds the Python object";
  input Boolean passPythonObject
    "Set to true if the Python function returns and receives an object, see User's Guide";

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
protected
  String pytPat "Value of PYTHONPATH environment variable";
  String pytPatBuildings "PYTHONPATH of Buildings library";
  Boolean havePytPat "true if PYTHONPATH is already set by the user";
//--  String filNam = "file://Utilities/IO/Python27/UsersGuide/package.mo"
//--    "Name to a file of the Buildings library";
algorithm
 // Get the directory to Buildings/Resources/Python-Sources
//-- The lines below do not work in Dymola 2014 due to an issue with the loadResource
//-- (ticket #15168). This will be fixed in future versions.
//-- pytPatBuildings := Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath(uri=filNam);
//-- pytPatBuildings := Modelica.Utilities.Strings.replace(
//--   string=pytPatBuildings,
//--   searchString=filNam,
//--   replaceString="Resources/Python-Sources");
 // The next line is a temporary fix for the above problem
 pytPatBuildings := "Resources/Python-Sources";
 // Update the PYTHONPATH variable
 (pytPat, havePytPat) :=Modelica.Utilities.System.getEnvironmentVariable("PYTHONPATH");
 if havePytPat then
   Modelica.Utilities.System.setEnvironmentVariable(name="PYTHONPATH",
      content=pytPat + ":" + pytPatBuildings);
 else
   Modelica.Utilities.System.setEnvironmentVariable(name="PYTHONPATH",
      content=pytPatBuildings);
 end if;
 // Call the exchange function
 (dblRea, intRea) :=BaseClasses.exchange(
    moduleName=moduleName,
    functionName=functionName,
    pytObj=pytObj,
    passPythonObject=passPythonObject,
    dblWri=dblWri,
    intWri=intWri,
    strWri=strWri,
    nDblWri=nDblWri,
    nDblRea=nDblRea,
    nIntWri=nIntWri,
    nIntRea=nIntRea,
    nStrWri=nStrWri);

 // Change the PYTHONPATH back to what it was so that the function has no
 // side effects.
 if havePytPat then
   Modelica.Utilities.System.setEnvironmentVariable(name="PYTHONPATH",
      content=pytPat);
 else
   Modelica.Utilities.System.setEnvironmentVariable(name="PYTHONPATH",
      content="");
 end if;

  annotation (Documentation(info="<html>
<p>
This function is a wrapper for
<a href=\"modelica://Buildings.Utilities.IO.Python27.Functions.BaseClasses.exchange\">
Buildings.Utilities.IO.Python27.Functions.BaseClasses.exchange</a>.
It adds the directory <code>modelica://Buildings/Resources/Python-Sources</code>
to the environment variable <code>PYTHONPATH</code>
prior to calling the function that exchanges data with Python.
After the function call, the <code>PYTHONPATH</code> is set back to what
it used to be when entering this function.
See
<a href=\"modelica://Buildings.Utilities.IO.Python27.UsersGuide\">
Buildings.Utilities.IO.Python27.UsersGuide</a>
for instructions, and
<a href=\"modelica://Buildings.Utilities.IO.Python27.Functions.Examples\">
Buildings.Utilities.IO.Python27.Functions.Examples</a>
for examples.
</p>
</html>", revisions="<html>
<ul>
<li>
May 2, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end exchange;
