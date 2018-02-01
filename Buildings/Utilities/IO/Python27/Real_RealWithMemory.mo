within Buildings.Utilities.IO.Python27;
model Real_RealWithMemory
  "Block that exchanges a vector of real values with a Python function"
  extends Modelica.Blocks.Interfaces.DiscreteBlock(
    startTime=0,
    firstTrigger(fixed=true, start=false));

  parameter String moduleName
    "Name of the python module that contains the function";
  parameter String functionName=moduleName "Name of the python function";

  parameter Integer nDblWri(min=1) "Number of double values to write to Python";
  parameter Integer nDblRea(min=1)
    "Number of double values to be read from the Python";
  parameter Integer flaDblWri[nDblWri] = zeros(nDblWri)
    "Flag for double values (0: use current value, 1: use average over interval, 2: use integral over interval)";

  Modelica.Blocks.Interfaces.RealInput uR[nDblWri]
    "Real inputs to be sent to Python"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput yR[nDblRea]
    "Real outputs received from Python"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Real uRInt[nDblWri] "Value of integral";
  Real uRIntPre[nDblWri] "Value of integral at previous sampling instance";
  Real uRWri[nDblWri] "Value to be sent to Python";
protected
  Buildings.Utilities.IO.Python27.Functions.BaseClasses.PythonObject pytObj=
    Buildings.Utilities.IO.Python27.Functions.BaseClasses.PythonObject();
initial equation
   uRWri    =  pre(uR);
   uRInt    =  zeros(nDblWri);
   uRIntPre =  zeros(nDblWri);
   for i in 1:nDblWri loop
     assert(flaDblWri[i]>=0 and flaDblWri[i]<=2,
        "Parameter flaDblWri out of range for " + String(i) + "-th component.");
   end for;
   // The assignment of yR avoids the warning
   // "initial conditions for variables of type Real are not fully specified".
   // At startTime, the sampleTrigger is true and hence this value will
   // be overwritten.
   yR = zeros(nDblRea);
equation
   for i in 1:nDblWri loop
      der(uRInt[i]) = if (flaDblWri[i] > 0) then uR[i] else 0;
   end for;

  when {sampleTrigger} then
     // Compute value that will be sent to Python
     for i in 1:nDblWri loop
       if (flaDblWri[i] == 0) then
         uRWri[i] = pre(uR[i]);                 // Send the current value.
       else
         uRWri[i] = uRInt[i] - pre(uRIntPre[i]);     // Integral over the sampling interval
         if (flaDblWri[i] == 1) then
            uRWri[i] =  uRWri[i]/samplePeriod;  // Average value over the sampling interval
         end if;
       end if;
      end for;

    // Exchange data
    yR = Buildings.Utilities.IO.Python27.Functions.exchangeWithMemory(
      moduleName=moduleName,
      functionName=functionName,
      dblWri=uRWri,
      intWri={0},
      nDblWri=nDblWri,
      nDblRea=nDblRea,
      nIntWri=0,
      nIntRea=0,
      nStrWri=0,
      strWri={""},
      pytObj=pytObj);

    // Store current value of integral
  uRIntPre= uRInt;
  end when;

  annotation (defaultComponentName="pyt",
 Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Bitmap(
            extent={{-88,82},{80,-78}}, fileName="modelica://Buildings/Resources/Images/Utilities/IO/Python27/python.png")}),
    Documentation(info="<html>
<p>
Block that exchanges data with a Python function that needs to pass
an object from one call to the next.
</p>
<p>
For each element in the input vector <code>uR[nDblWri]</code>,
the value of the flag <code>flaDblWri[nDblWri]</code> determines whether
the current value, the average over the sampling interval or the integral
over the sampling interval is sent to Python. The following three options are allowed:
</p>
<br/>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
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
<p>
If the function does not need to pass an object from one invocation to the
next, use
<a href=\"modelica://Buildings.Utilities.IO.Python27.Real_Real\">
Buildings.Utilities.IO.Python27.Real_Real</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 31, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Real_RealWithMemory;
