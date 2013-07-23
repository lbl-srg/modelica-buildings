within Buildings.Rooms.Examples.FLEXLAB.IO;
model CalBaySetDAQ "Block calling a Python script to send signals to CalBay"
  extends Modelica.Blocks.Interfaces.DiscreteBlock(startTime=0);

  parameter String moduleName
    "Name of the python module that contains the function";
  parameter String functionName=moduleName "Name of the python function";
  parameter String Login "Login used in the CalBay system";
  parameter String Password "Password used in the CalBay system";

  parameter Integer nDblRea
    "Number of real variables to be read from the Python script";

  String SendString
    "Concatenate the three inputs to the string needed in Python";

  String Command "Command being sent to CalBay";

  Modelica.Blocks.Interfaces.RealOutput yR[nDblRea]
    "Real outputs received from Python"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.BooleanInput u
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
algorithm

    if u == true then
      Command :="SetDAQ:WattStopper.HS1--4126F--Light Level-1:1";
    else
      Command :="SetDAQ:WattStopper.HS1--4126F--Light Level-1:0";
    end if;

    SendString :=Command + ":" + Login + ":" + Password;

    // Exchange data
    yR :=Buildings.Utilities.IO.Python27.Functions.exchange(
      moduleName=moduleName,
      functionName=functionName,
      dblWri={0},
      intWri={0},
      nDblWri=0,
      nDblRea=nDblRea,
      nIntWri=0,
      nIntRea=0,
      nStrWri=1,
      strWri={SendString});

  annotation (defaultComponentName="pyt",
   Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,100}}),
                               graphics), Icon(coordinateSystem(
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
end CalBaySetDAQ;
