within Buildings.Controls.Continuous;
block LimPID
  "P, PI, PD, and PID controller with limited output, anti-windup compensation and setpoint weighting"
  extends Modelica.Blocks.Continuous.LimPID(
    addP(k1=revAct*wp, k2=-revAct),
    addD(k1=revAct*wd, k2=-revAct),
    addI(k1=revAct, k2=-revAct),
    yMin=0,
    yMax=1);

  parameter Boolean reverseAction = false
    "Set to true for throttling the water flow rate through a cooling coil controller";
protected
  parameter Real revAct = if reverseAction then -1 else 1;
  annotation (
defaultComponentName="conPID",
Documentation(info="<html>
<p>
This model is identical to
<a href=\"modelica://Modelica.Blocks.Continuous.LimPID\">
Modelica.Blocks.Continuous.LimPID</a> except
that it can be configured to have a reverse action.
</p>
<p>
If the parameter <code>reverseAction=false</code> (the default),
then <code>u_m &lt; u_s</code> increases the controller output,
otherwise the controller output is decreased.
Thus,
</p>
<ul>
<li>
for a heating coil with a two-way valve, set <code>reverseAction = false</code>,
</li>
<li>
for a cooling coils with a two-way valve, set <code>reverseAction = true</code>.
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
February 24, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(graphics={
        Rectangle(
          extent={{-6,-20},{66,-66}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          visible=(controllerType == Modelica.Blocks.Types.SimpleController.P),
          extent={{-32,-22},{68,-62}},
          lineColor={0,0,0},
          textString="P",
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175}),
        Text(
          visible=(controllerType == Modelica.Blocks.Types.SimpleController.PI),
          extent={{-28,-22},{72,-62}},
          lineColor={0,0,0},
          textString="PI",
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175}),
        Text(
          visible=(controllerType == Modelica.Blocks.Types.SimpleController.PD),
          extent={{-16,-22},{88,-62}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175},
          textString="P D"),
        Text(
          visible=(controllerType == Modelica.Blocks.Types.SimpleController.PID),
          extent={{-14,-22},{86,-62}},
          lineColor={0,0,0},
          textString="PID",
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175})}));
end LimPID;
