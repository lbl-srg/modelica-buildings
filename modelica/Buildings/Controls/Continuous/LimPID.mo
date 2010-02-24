within Buildings.Controls.Continuous;
block LimPID
  "P, PI, PD, and PID controller with limited output, anti-windup compensation and setpoint weighting"
  extends Modelica.Blocks.Continuous.LimPID(
    addP(k1=revAct*wp, k2=-revAct),
    addD(k1=revAct*wd, k2=-revAct),
    addI(k1=revAct, k2=-revAct),
    yMin=0,
    yMax=1);

  annotation (Documentation(info="<html>
This model is identical to 
<a href=\"Modelica:Modelica.Blocks.Continuous.LimPID\">
Modelica.Blocks.Continuous.LimPID</a> except
that it can be configured to have a reverse action.
</P>
<p>
If the parameter <code>reverseAction=false</code> (the default),
then <code>u_m &lt; u_s</code> increases the controller output, 
otherwise the controller output is decreased.
Thus, a heating coils, set <code>reverseAction = false</code> but 
for cooling coils, set <code>reverseAction = true</code>.
</html>",
revisions="<html>
<ul>
<li>
February 24, 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  parameter Boolean reverseAction = false
    "Set to true to enable reverse action (such as for a cooling coil controller)";
protected
  parameter Real revAct = if reverseAction then 1 else -1;
end LimPID;
