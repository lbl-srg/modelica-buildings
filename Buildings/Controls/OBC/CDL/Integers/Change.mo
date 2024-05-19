within Buildings.Controls.OBC.CDL.Integers;
block Change
  "Output whether the Integer input changes values, increases or decreases"
  parameter Integer pre_u_start=0
    "Start value of pre(u) at initial time";
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput u
    "Connector of Integer input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y
    "Connector of Boolean output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput up
    "Connector of Boolean output signal indicating input increase"
    annotation (Placement(transformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput down
    "Connector of Boolean output signal indicating input decrease"
    annotation (Placement(transformation(extent={{100,-80},{140,-40}})));

initial equation
  pre(u)=pre_u_start;

equation
  y=change(u);
  up=u > pre(u);
  down=u < pre(u);
  annotation (
    defaultComponentName="cha",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true),
      graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          lineThickness=5.0,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Text(
          extent={{-50,62},{50,-56}},
          textColor={255,127,0},
          textString="change"),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255})}),
    Documentation(
      info="<html>
<p>
Block that evaluates the integer input <code>u</code> to check if its value
changes.
</p>
<ul>
<li>
When the input <code>u</code> changes, the output <code>y</code> will be
<code>true</code>, otherwise it will be <code>false</code>.
</li>
<li>
When the input <code>u</code> increases, the output <code>up</code> will be
<code>true</code>, otherwise it will be <code>false</code>.
</li>
<li>
When the input <code>u</code> decreases, the output <code>down</code> will be
<code>true</code>, otherwise it will be <code>false</code>.
</li>
</ul>
</html>",
      revisions="<html>
<ul>
<li>
May 3, 2022, by Michael Wetter:<br/>
Renamed parameter <code>y_start</code> to <code>pre_u_start</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2990\">#2990</a>.
</li>
<li>
January 26, 2021, by Michael Wetter:<br/>
Changed initialization of <code>pre(u)</code> to use the initial value of the input rather than <code>0</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2294\">#2294</a>.
</li>
<li>
July 18, 2018, by Michael Wetter:<br/>
Revised model and icon.
</li>
<li>
July 13, 2018, by Jianjun Hu:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end Change;
