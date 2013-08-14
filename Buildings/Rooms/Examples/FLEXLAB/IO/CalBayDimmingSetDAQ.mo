within Buildings.Rooms.FLEXLAB.IO;
model CalBayDimmingSetDAQ
  "Block calling a Python script to send signals to CalBay"
  extends Modelica.Blocks.Interfaces.DiscreteBlock(startTime=0);

  parameter String moduleName
    "Name of the python module that contains the function";
  parameter String functionName=moduleName "Name of the python function";
  parameter String Login "Login used in the CalBay system";
  parameter String Password "Password used in the CalBay system";
//   parameter Buildings.Rooms.FLEXLAB.Types.Signal Signal
//     "Type of signal used in communication with CalBay"
//     annotation(choicesAllMatching=true);
//   parameter Buildings.Rooms.FLEXLAB.Types.Server Server
//     "CalBay server used in the current communication"
//     annotation(choicesAllMatching=true);
  parameter String Channel "Channel on the server used for communication";

  parameter Integer nDblRea
    "Number of real variables to be read from the Python script";

  String SendString
    "Concatenate the three inputs to the string needed in Python";

  String Command "Command being sent to CalBay";
//   String SignalType "Type of signal to send to CalBay";
//   String Receiver "Server receiving the command";

  Modelica.Blocks.Interfaces.RealOutput yR[nDblRea]
    "Real outputs received from Python"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput uR
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
algorithm
//initial equation, python function to get current time. Use current time in this model
//How to set sample trigger to happen at current time + every 5-10s? How does sample trigger work?

  when {sampleTrigger} then
//     if Signal == Buildings.Rooms.FLEXLAB.Types.Signal.GetDAQ then
//       SignalType :="GetDAQ";
//     else
//       SignalType :="SetDAQ";
//     end if;
//
//     if Server == Buildings.Rooms.FLEXLAB.Types.Server.FourthFloor then
//       Receiver :="4th Floor";
//     else
//       Receiver :="WattStopper.HS1";
//     end if;

      Command :=String(uR);

//    SendString :=SignalType + ":" + Receiver + Channel + ":" + Command + ":" + Login + ":" + Password;
    SendString := Channel + ":" + Command + ":" + Login + ":" + Password;

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
end CalBayDimmingSetDAQ;
