within Buildings.Utilities.IO.Python27.Functions;
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
protected
  String pytPat "Value of PYTHONPATH environment variable";
  String pytPatBuildings "PYTHONPATH of Buildings library";
  Boolean havePytPat "true if PYTHONPATH is already set by the user";
//  String filNam = "Utilities/IO/Python27/UsersGuide/package.mo"
//    "Name to a file of the Buildings library";
algorithm
 // Get the directory to Buildings/Resources/Python-Sources

 // fixme: the line below causes a compile time error in Dymola with the following information
 /*
 In file included from dsmodel.c:7:0:
/opt/dymola/source/matrixop.h:73:22: warning: 'EndRealbuffer' initialized and declared 'extern' [enabled by default]
/opt/dymola/source/matrixop.h:74:25: warning: 'EndIntegerbuffer' initialized and declared 'extern' [enabled by default]
/opt/dymola/source/matrixop.h:75:26: warning: 'EndSizebuffer' initialized and declared 'extern' [enabled by default]
/opt/dymola/source/matrixop.h:76:24: warning: 'EndStringbuffer' initialized and declared 'extern' [enabled by default]
/opt/dymola/source/matrixop.h:77:22: warning: 'Endsimplestring' initialized and declared 'extern' [enabled by default]
dsmodel.c: In function 'Buildings_BoundaryConditions_WeatherData_BaseClasses_getAbsolutePath':
dsmodel.c:259:5: warning: passing argument 1 of 'SqueezeString' discards 'const' qualifier from pointer target type [enabled by default]
/opt/dymola/source/matrixop1.h:106:21: note: expected 'char *' but argument is of type 'const char *'
dsmodel.c: In function 'Buildings_Utilities_IO_Python27_Functions_BaseClasses_exchange_M':
dsmodel.c:312:9: warning: passing argument 7 of 'pythonExchangeValues' from incompatible pointer type [enabled by default]
/home/mwetter/proj/ldrd/bie/modeling/github/lbl-srg/modelica-buildings/Buildings/Resources/src/python/python27Wrapper.c:20:6: note: expected 'const int *' but argument is of type 'Integer *'
dsmodel.c:312:9: warning: passing argument 9 of 'pythonExchangeValues' from incompatible pointer type [enabled by default]
/home/mwetter/proj/ldrd/bie/modeling/github/lbl-srg/modelica-buildings/Buildings/Resources/src/python/python27Wrapper.c:20:6: note: expected 'int *' but argument is of type 'Integer *'
dsmodel.c: In function 'ModelicaServices_ExternalReferences_loadResource':
dsmodel.c:368:24: warning: assignment makes pointer from integer without a cast [enabled by default]
dsmodel.c:371:5: warning: passing argument 1 of 'SqueezeString' discards 'const' qualifier from pointer target type [enabled by default]
/opt/dymola/source/matrixop1.h:106:21: note: expected 'char *' but argument is of type 'const char *'
/tmp/cc0FSt6v.o: In function `ModelicaServices_ExternalReferences_loadResource':
dsmodel.c:(.text+0x52fa): undefined reference to `Dymola_ResolveURI'
collect2: ld returned 1 exit status
  
 */
// pytPatBuildings := Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath(uri=filNam);
 /*pytPatBuildings := Modelica.Utilities.Strings.replace(
   string=pytPatBuildings,
   searchString=filNam,
   replaceString="Resources/Python-Sources");
 */
 // Fixme: the next line is a temporary fix for the above problem
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
May 2, 2013, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end exchange;
