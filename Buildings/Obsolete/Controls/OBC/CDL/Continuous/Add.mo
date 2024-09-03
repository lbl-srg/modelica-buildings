within Buildings.Obsolete.Controls.OBC.CDL.Continuous;
block Add "Output the sum of the two inputs"
  extends Modelica.Icons.ObsoleteModel;

  parameter Real k1=+1
    "Gain for input u1";
  parameter Real k2=+1
    "Gain for input u2";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u1
    "Connector of Real input signal 1"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u2
    "Connector of Real input signal 2"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

equation
  y=k1*u1+k2*u2;
  annotation (
    defaultComponentName="add2",
    obsolete = "This model is obsolete",
    Documentation(
      info="<html>
<p>
Block that outputs <code>y</code> as the weighted <i>sum</i> of the
two input signals <code>u1</code> and <code>u2</code>,
</p>
<pre>
    y = k1*u1 + k2*u2;
</pre>
<p>
where <code>k1</code> and <code>k2</code> are parameters.
</p>
</html>",
      revisions="<html>
<ul>
<li>
March 2, 2020, by Michael Wetter:<br/>
Changed icon to display dynamically the output value.
</li>
<li>
January 3, 2017, by Michael Wetter:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"),
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          lineColor={0,0,127},
          extent={{-50,-50},{50,50}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255}),
        Line(
          points={{-100,60},{-74,24},{-44,24}},
          color={0,0,127}),
        Line(
          points={{-100,-60},{-74,-28},{-42,-28}},
          color={0,0,127}),
        Line(
          points={{50,0},{100,0}},
          color={0,0,127}),
        Text(
          extent={{-40,-22},{36,46}},
          textString="+"),
        Text(
          extent={{-100,52},{5,92}},
          textString="%k1"),
        Text(
          extent={{-100,-92},{5,-52}},
          textString="%k2"),
        Text(
          extent={{226,60},{106,10}},
          textColor={0,0,0},
          textString=DynamicSelect("",String(y,
            leftJustified=false,
            significantDigits=3)))}));
end Add;
