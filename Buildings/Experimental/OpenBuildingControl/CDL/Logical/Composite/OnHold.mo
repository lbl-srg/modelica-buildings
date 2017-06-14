within Buildings.Experimental.OpenBuildingControl.CDL.Logical.Composite;
block OnHold "Block that holds a signal on for a requested time period"

  parameter Modelica.SIunits.Time holdDuration "Time duration of the on hold.";

  Interfaces.BooleanInput u "Boolean input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));
  Interfaces.BooleanOutput y "Boolean output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));

  Logical.Timer timer "Timer to measure time elapsed after the output signal rising edge"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));

protected
  Logical.LessThreshold les1(final threshold=holdDuration) "Less than threshold"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Continuous.Constant Zero(final k=0) "Constant equals zero"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Logical.Pre pre "Introduces infinitesimally small time delay"
    annotation (Placement(transformation(extent={{50,40},{70,60}})));
  Logical.Not not1 "Not block"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Logical.Equal equ1 "Equal block"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Logical.Or or2 "Or block" annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Logical.And and2 "And block" annotation (Placement(transformation(extent={{20,40},{40,60}})));

equation
  connect(timer.u,pre. y) annotation (Line(points={{18,20},{12,20},{12,0},{80,0},
          {80,50},{71,50}},
                      color={255,0,255}));
  connect(timer.y,equ1. u2) annotation (Line(points={{41,20},{60,20},{60,-50},{
          -70,-50},{-70,-38},{-62,-38}},                          color={0,0,
          127}));
  connect(u, or2.u1) annotation (Line(points={{-120,0},{-90,0},{-90,70},{-22,70}},
        color={255,0,255}));
  connect(les1.y, and2.u2) annotation (Line(points={{1,-30},{10,-30},{10,42},{18,
          42}},      color={255,0,255}));
  connect(and2.y, pre.u) annotation (Line(points={{41,50},{48,50}},
                 color={255,0,255}));
  connect(or2.y, y) annotation (Line(points={{1,70},{1,70},{90,70},{90,0},{110,0}},
        color={255,0,255}));
  connect(timer.y, les1.u) annotation (Line(points={{41,20},{60,20},{60,-50},{
          -30,-50},{-30,-30},{-22,-30}},      color={0,0,127}));
  connect(or2.y, and2.u1) annotation (Line(points={{1,70},{10,70},{10,50},{18,50}},
        color={255,0,255}));
  connect(equ1.u1, Zero.y)
    annotation (Line(points={{-62,-30},{-62,-30},{-79,-30}}, color={0,0,127}));
  connect(equ1.y, not1.u) annotation (Line(points={{-39,-30},{-32,-30},{-32,20},
          {-70,20},{-70,50},{-62,50}}, color={255,0,255}));
  connect(not1.y, or2.u2) annotation (Line(points={{-39,50},{-30,50},{-30,62},{-22,
          62}}, color={255,0,255}));
  annotation (Icon(graphics={    Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          lineThickness=5.0,
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
          Line(points={{-72,18},{-48,18},{-48,62},{52,62},{52,18},{80,18}},
              color={255,0,255}),
          Line(points={{-68,-46},{-48,-46},{-48,-2},{22,-2},{22,-46},{78,-46}}),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          lineColor={0,0,255}),
        Text(
          extent={{-90,-62},{96,-90}},
          lineColor={0,0,255},
          textString="%holdDuration")}), Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
              Documentation(info="<html>
<p>
Block that holds a true signal for a defined time period.
</p>
<p>
If the input <code>u</code> becomes <code>true</code>, a timer starts
and the Boolean output <code>y</code> stays <code>true</code> for the time
period provided by the parameter <code>holdDuration</code>.
When this time is elapsed, the input is checked again. If
it is <code>true</code>, then the timer is restarted and the output remains
<code>true</code> for another <code>holdDuration</code> seconds.
If the input <code>u</code> is <code>false</code> when the timer is running for
<code>holdTime</code> seconds, then the ouput is switched to <code>false</code>.
</p>
<p>
The figure below shows an example with a hold time of <i>3600</i> seconds
and a pulse width period <i>9000</i> seconds that starts at <i>t=200</i> seconds.
</p>

<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/CDL/Logical/Composite/OnHold.png\"
alt=\"Input and output of the block\"/>
</p>

<p>
The figure below shows an example with a hold time of <i>60</i> seconds
and a pulse width period <i>3600</i> seconds that starts at <i>t=0</i> seconds.
</p>

<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/CDL/Logical/Composite/OnHold1.png\"
alt=\"Input and output of the block\"/>
    </p>
</html>", revisions="<html>
<ul>
<li>
June 13, 2017, by Michael Wetter:<br/>
Revised documentation.
</li>
<li>
May 24, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end OnHold;
