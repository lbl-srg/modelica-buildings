within Buildings.Utilities.IO;
package Python27 "Package to call Python functions"
  extends Modelica.Icons.VariantsPackage;



  model Cymdist
  "Block that exchanges a vector of real values with CymDist"
  extends Modelica.Blocks.Interfaces.DiscreteBlock(startTime=0);
  parameter String inFileName="" "Name of input file" annotation (Dialog(
        __Dymola_loadSelector(filter="input files (*.txt)", caption=
            "Select input file")));
  parameter String outFileName="" "Name of output file" annotation (Dialog(
        __Dymola_loadSelector(filter="output files (*.txt)", caption=
            "Select output file")));

  final parameter Integer nInpLin = Modelica.Utilities.Streams.countLines(inFileName)
    "Number of lines in the input file";
  final parameter Integer nOutLin = Modelica.Utilities.Streams.countLines(outFileName)
    "Number of lines in the output file";
  parameter String moduleName
    "Name of the Python module that contains the function";
  parameter String functionName = moduleName "Name of the python function";
  final parameter Integer nDblWri(min=1) = nInpLin
    "Number of double values to write to Python";
  final parameter Integer nDblRea(min=1) = nOutLin
    "Number of double values to be read from the Python";
  parameter Integer flaDblWri[nDblWri] = zeros(nDblWri)
    "Flag for double values (0: use current value, 1: use average over interval, 
    2: use integral over interval)";
  final parameter Integer nStrWri(min=1) = nInpLin "Number of strings to write";
  final parameter Integer nStrRea(min=1) = nOutLin "Number of strings to read";
  final parameter String  strWri[max(1, nStrWri)] = Modelica.Utilities.Streams.readFile(inFileName)
    "String values to write";
  final parameter String  strRea[max(1, nStrRea)] = Modelica.Utilities.Streams.readFile(outFileName)
    "String values to read";
  Modelica.Blocks.Interfaces.RealInput uR[nDblWri]
    "Real inputs to be sent to Python"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput yR[nDblRea]
    "Real outputs received from Python"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Real uRInt[nDblWri] "Value of integral";
  Real uRIntPre[nDblWri] "Value of integral at previous sampling instance";
public
  Real uRWri[nDblWri] "Value to be sent to Python";
  initial algorithm
   uRInt    := zeros(nDblWri);
   uRIntPre := zeros(nDblWri);
   for i in 1:nDblWri loop
     assert(flaDblWri[i]>=0 and flaDblWri[i]<=2,
        "Parameter flaDblWri out of range for " + String(i) + "-th component.");
   end for;
  equation
   for i in 1:nDblWri loop
      der(uRInt[i]) = if (flaDblWri[i] > 0) then uR[i] else 0;
   end for;
  algorithm
  when {sampleTrigger} then
     // Compute value that will be sent to Python
     for i in 1:nDblWri loop
       if (flaDblWri[i] == 0) then
         uRWri[i] :=pre(uR[i]);                 // Send the current value.
       else
         uRWri[i] :=uRInt[i] - uRIntPre[i];     // Integral over the sampling interval
         if (flaDblWri[i] == 1) then
            uRWri[i] := uRWri[i]/samplePeriod;  // Average value over the sampling interval
         end if;
       end if;
      end for;
    // Exchange data
    yR :=Buildings.Utilities.IO.Python27.Functions.cymdist(
      moduleName=moduleName,
      functionName=functionName,
      dblWri=uRWri,
      intWri={0},
      nDblWri=nDblWri,
      nDblRea=nDblRea,
      nIntWri=0,
      nIntRea=0,
      nStrWri=nStrWri,
      nStrRea=nStrRea,
      strWri=strWri,
      strRea=strRea);
    // Store current value of integral
  uRIntPre:=uRInt;
  end when;
  annotation (defaultComponentName="pyt",
   Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}),            graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Bitmap(
            extent={{-88,82},{80,-78}}, fileName="modelica://Buildings/Resources/Images/Utilities/IO/Python27/python.png")}),
    Documentation(info="<html>
Block that exchanges data with a Python function.<br/>
<p>
For each element in the input vector <code>uR[nDblWri]</code>, 
the value of the flag <code>flaDblWri[nDblWri]</code> determines whether
the current value, the average over the sampling interval or the integral
over the sampling interval is sent to Python. The following three options are allowed:
</p>
<br/>
<table summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
<tr>
<td>
flaDblWri[i]
</td>
<td>
Value sent to Python
</td>
</tr>
<tr>
<td>
0
</td>
<td>
Current value of uR[i]
</td>
</tr>
<tr>
<td>
1
</td>
<td>
Average value of uR[i] over the sampling interval
</td>
</tr>
<tr>
<td>
2
</td>
<td>
Integral of uR[i] over the sampling interval
</td>
</tr>
</table>
<br/>
</html>", revisions="<html>
<ul>
<li>
February 5, 2013, by Michael Wetter:<br/>
First implementation, 
based on
<a href=\"modelica://Buildings.Utilities.IO.BCVTB.BCVTB\">
Buildings.Utilities.IO.BCVTB.BCVTB</a>.
</li>
</ul>
</html>"));
  end Cymdist;



annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains blocks and functions that embed Python 2.7 in Modelica.
Data can be sent to Python functions and received from Python functions.
This allows for example data analysis in Python as part of a Modelica model,
or data exchange as part of a hardware-in-the-loop simulation in which
Python is used to communicate with hardware.
</p>
<p>
See
<a href=\"modelica://Buildings.Utilities.IO.Python27.UsersGuide\">
Buildings.Utilities.IO.Python27.UsersGuide</a>
for instruction.
</p>
</html>"));
end Python27;
