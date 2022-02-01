within Buildings.Utilities.IO.Python_3_8.Functions;
impure function exchange "Function that communicates with Python"
  extends Modelica.Icons.Function;

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
  String pytPatOld "Old value of PYTHONPATH environment variable";
  String pytPatBuildings "PYTHONPATH of Buildings library";
  String pytPat "Value of PYTHONPATH environment variable";
  Boolean havePytPat "true if PYTHONPATH is already set by the user";
  package P
    constant String filNam = "modelica://Buildings/legal.html"
        "Name to a file of the Buildings library";
    constant String buiLibFil = Modelica.Utilities.Files.loadResource(uri=filNam) "Absolute path to filNam";
  end P;
  String searchString = "legal.html" "String to be replaced";
algorithm
 // Get the directory to Buildings/Resources/Python-Sources
 pytPatBuildings := Modelica.Utilities.Strings.replace(
   string=P.buiLibFil,
   searchString=searchString,
   replaceString="Resources/Python-Sources");

 // Update the PYTHONPATH variable
 (pytPatOld, havePytPat) :=Modelica.Utilities.System.getEnvironmentVariable("PYTHONPATH");
 if havePytPat then
   if Modelica.Utilities.Strings.find(pytPatOld, pytPatBuildings) == 0 then
     // The new python path is not yet in the environment variable, add it.
     pytPat:=pytPatOld + ":" + pytPatBuildings;
   else
     // The new python path is already in the variable.
     pytPat:=pytPatOld;
   end if;
 else
   pytPat := pytPatBuildings;
 end if;
 // Call the exchange function
 (dblRea, intRea) :=BaseClasses.exchange(
    moduleName=moduleName,
    functionName=functionName,
    pytObj=pytObj,
    passPythonObject=passPythonObject,
    pythonPath=pytPat,
    dblWri=dblWri,
    intWri=intWri,
    strWri=strWri,
    nDblWri=nDblWri,
    nDblRea=nDblRea,
    nIntWri=nIntWri,
    nIntRea=nIntRea,
    nStrWri=nStrWri);
  annotation (Documentation(info="<html>
<p>
This function is a wrapper for
<a href=\"modelica://Buildings.Utilities.IO.Python_3_8.Functions.BaseClasses.exchange\">
Buildings.Utilities.IO.Python_3_8.Functions.BaseClasses.exchange</a>.
It adds the directory <code>modelica://Buildings/Resources/Python-Sources</code>
to the environment variable <code>PYTHONPATH</code>
prior to calling the function that exchanges data with Python.
After the function call, the <code>PYTHONPATH</code> is set back to what
it used to be when entering this function.
See
<a href=\"modelica://Buildings.Utilities.IO.Python_3_8.UsersGuide\">
Buildings.Utilities.IO.Python_3_8.UsersGuide</a>
for instructions, and
<a href=\"modelica://Buildings.Utilities.IO.Python_3_8.Functions.Examples\">
Buildings.Utilities.IO.Python_3_8.Functions.Examples</a>
for examples.
</p>
</html>", revisions="<html>
<ul>
<li>
August 27, 2021, by Michael Wetter:<br/>
Updated to Python 3.8.
</li>
<li>
April 10, 2020, by Jianjun Hu and Michael Wetter:<br/>
Updated to Python 3.6.
</li>
<li>
June 14, 2019, by Antoine Gautier and Michael Wetter:<br/>
Refactored for setting <code>PYTHONPATH</code> correctly independent of working directory.
</li>
<li>
April 24, 2019, by Michael Wetter:<br/>
Refactored for getting <code>PYTHONPATH</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1421\">#1421</a>.
</li>
<li>
May 2, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end exchange;
