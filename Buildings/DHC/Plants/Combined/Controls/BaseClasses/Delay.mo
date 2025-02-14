within Buildings.DHC.Plants.Combined.Controls.BaseClasses;
block Delay "Delay input"

  parameter Real delayTime(
    final quantity="Time",
    final unit="s")
    "Delay time";
  parameter Real delayMax(
    final quantity="Time",
    final unit="s",
    final min=delayTime)=delayTime
    "Maximum delay time";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput u
    "Real input to be delayed"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Delayed input"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

equation
  y=delay(u, delayTime, delayMax);

annotation (defaultComponentName="del",
  __cdl(extensionBlock=true),
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          textColor={0,0,255},
          extent={{-100,100},{100,140}},
          textString="%name")}), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
Documentation(info="<html>
<p>
Returns <code>u(time - delayTime)</code> for <code>time &gt; time.start + delayTime</code>
and <code>u(time.start)</code> for <code>time &le; time.start + delayTime</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 12, 2025, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Delay;
