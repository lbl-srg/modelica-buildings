within Buildings.Utilities.IO.Python27.Functions;
package BaseClasses "Package with functions that call Python"
function cymdist "Function that communicates with Python"
  input String moduleName
    "Name of the python module that contains the function";
  input String functionName=moduleName "Name of the python function";
  input Real    dblInpVal[max(1, nDblInp)] "Input variables values to be sent to CYMDIST";
  input Real    dblParVal[max(1, nDblPar)] "Parameter variables values to send to CYMDIST";
  input String  dblOutNam[max(1, nDblOut)] "Output variables names to be read from CYMDIST";
  input String  dblInpNam[max(1, nDblInp)] "Input variables names to be sent to CYMDIST";
  input String  dblParNam[max(1, nDblPar)] "Parameter variables names to send to CYMDIST";
  input Integer nDblInp(min=0) "Number of double inputs to send to CYMDIST";
  input Integer nDblOut(min=0) "Number of double outputs to read from CYMDIST";
  input Integer nDblPar(min=0) "Number of double parameters to send to CYMDIST";
//   input Integer strLenRea(min=0)
//     "Maximum length of each string that is read. If exceeded, the simulation stops with an error";
  output Real    dblOutVal[max(1, nDblOut)] "Double output values read from CYMDIST";
  external "C" pythonExchangeValuesCymdist(moduleName, functionName,
                                    nDblInp, dblInpNam,
                                    dblInpVal, nDblOut,
                                    dblOutNam, dblOutVal,
                                    nDblPar, dblParNam,
                                    dblParVal)
    annotation (Library={"ModelicaBuildingsPython2.7",  "python2.7"},
      LibraryDirectory={"modelica://Buildings/Resources/Library"},
      IncludeDirectory="modelica://Buildings/Resources/C-Sources",
      Include="#include \"python27Wrapper.c\"");
  annotation (Documentation(info="<html>
<p>
This function exchanges data with CymDist through Python.
See 
<a href=\"modelica://Buildings.Utilities.IO.Python27.UsersGuide\">
Buildings.Utilities.IO.Python27.UsersGuide</a>
for instructions, and 
<a href=\"modelica://Buildings.Utilities.IO.Python27.Functions.Examples\">
Buildings.Utilities.IO.Python27.Functions.Examples</a>
for examples.
</p>
<p>
fixme: This function is similar to the exchange function but the 
definition of the strings strWri and strRea are different in this context.
Here strWi and strRea are the names of the inputs and outputs of a Cymdist FMU.
We will need to see whether we should change the name or consolidate the two 
</p>
</html>", revisions="<html>
<ul>
<li>
October 17, 2016, by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"));
end cymdist;

  extends Modelica.Icons.BasesPackage;


annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains functions that call Python.
</p>
</html>"));
end BaseClasses;
