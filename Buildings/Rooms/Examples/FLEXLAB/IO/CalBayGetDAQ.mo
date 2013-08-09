within Buildings.Rooms.FLEXLAB.IO;
model CalBayGetDAQ "Block calling a Python script to communicate with CalBay"
  extends Modelica.Blocks.Interfaces.DiscreteBlock(startTime=0);

  parameter String moduleName
    "Name of the python module that contains the function";
  parameter String functionName=moduleName "Name of the python function";
  parameter String Login "Login used in the CalBay system";
  parameter String Password "Password used in the CalBay system";
  parameter String Command "Command to send to CalBay";

  parameter Integer nDblRea
    "Number of real variables to be read from the Python script";

  String SendString = Command + ":" + Login + ":" + Password
    "Concatenate the three inputs to the string needed in Python";

  Modelica.Blocks.Interfaces.RealOutput yR[nDblRea]
    "Real outputs received from Python"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
algorithm
  when {sampleTrigger} then
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
  end when;
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
end CalBayGetDAQ;
