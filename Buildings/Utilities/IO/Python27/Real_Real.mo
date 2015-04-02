within Buildings.Utilities.IO.Python27;
model Real_Real
  "Block that exchanges a vector of real values with a Python function"
  extends Modelica.Blocks.Interfaces.DiscreteBlock(startTime=0);

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
public
  Real uRWri[nDblWri] "Value to be sent to Python";
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
    yR = Buildings.Utilities.IO.Python27.Functions.exchange(
      moduleName=moduleName,
      functionName=functionName,
      dblWri=uRWri,
      intWri={0},
      nDblWri=nDblWri,
      nDblRea=nDblRea,
      nIntWri=0,
      nIntRea=0,
      nStrWri=0,
      strWri={""});

    // Store current value of integral
  uRIntPre= uRInt;
  end when;

  annotation (defaultComponentName="pyt",
 Icon(coordinateSystem(
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
<br/>
</html>", revisions="<html>
<ul>
<li>
September 29, 2014, by Michael Wetter:<br/>
Changed <code>algorithm</code> to <code>equation</code> section
and assigned start values to avoid a translation warning in
Dymola.
</li>
<li>
February 5, 2013, by Michael Wetter:<br/>
First implementation,
based on
<a href=\"modelica://Buildings.Utilities.IO.BCVTB.BCVTB\">
Buildings.Utilities.IO.BCVTB.BCVTB</a>.
</li>
</ul>
</html>"));
end Real_Real;
