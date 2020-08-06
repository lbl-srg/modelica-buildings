within Buildings.Obsolete.Controls.OBC.CDL.Continuous;
block LessEqual
  "Output y is true, if input u1 is less or equal than input u2"
  extends Modelica.Icons.ObsoleteModel;

  Buildings.Controls.OBC.CDL.Interfaces.RealInput u1 "Connector of first Real input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput u2 "Connector of second Real input signal"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y "Connector of Boolean output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

equation
  y = u1 <= u2;
  annotation (
        defaultComponentName="lesEqu",
        obsolete = "Obsolete model, use Buildings.Controls.OBC.CDL.Continuous.Less instead",
        Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          lineThickness=5.0,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Ellipse(
          extent={{73,7},{87,-7}},
          lineColor=DynamicSelect({235,235,235}, if y then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if y then {0,255,0}
               else {235,235,235}),
          fillPattern=FillPattern.Solid),
        Ellipse(extent={{32,10},{52,-10}}, lineColor={0,0,127}),
        Line(points={{-100,-80},{42,-80},{42,0}}, color={0,0,127}),
        Line(
          points={{-10,20},{-54,0},{-10,-18}},
          thickness=0.5),
        Line(
          points={{-54,-18},{-14,-34}},
          thickness=0.5),
        Text(
          extent={{-150,150},{150,110}},
          lineColor={0,0,255},
          textString="%name")}),
                            Documentation(info="<html>
<p>
Block that outputs <code>true</code> if the Real input <code>u1</code>
is less than or equal to the Real input <code>u2</code>.
Otherwise the output is <code>false</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 6, 2020, by Michael Wetter:<br/>
Moved block to obsolete package.
</li>
<li>
January 3, 2017, by Michael Wetter:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end LessEqual;
