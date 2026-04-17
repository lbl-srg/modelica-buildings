within Buildings.Controls.OBC.DemandFlexibility.Generic.Subsequences;
block RealEqual "Check whether two real numbers are approximately equal"
  parameter Real alwDev(min=1E-6)
    "Allowed deviation for equality";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u1 "Input real number 1"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u2 "Input real number 2"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y
    "True if two real inputs are approximately equal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract                        sub
    "Input u1 minus input u2"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold                                      lesThr(t=alwDev, h=alwDev
        *0.5)
    "Whether the difference is less than the allowed deviation"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Reals.Abs abs1 "Absolute value of the difference between u1 and u2"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
equation
  connect(u1, sub.u1) annotation (Line(points={{-120,60},{-90,60},{-90,6},{-82,6}},
        color={0,0,127}));
  connect(u2, sub.u2) annotation (Line(points={{-120,-60},{-90,-60},{-90,-6},{-82,
          -6}}, color={0,0,127}));
  connect(sub.y, abs1.u)
    annotation (Line(points={{-58,0},{-42,0}}, color={0,0,127}));
  connect(abs1.y, lesThr.u)
    annotation (Line(points={{-18,0},{18,0}}, color={0,0,127}));
  connect(lesThr.y, y)
    annotation (Line(points={{42,0},{120,0}}, color={255,0,255}));
  annotation (defaultComponentName="reaEqu",
        Icon(coordinateSystem(preserveAspectRatio=false), graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-100,140},{100,100}},
          textColor={0,0,255},
          textString="%name")}),                           Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This block checks whether the values of two real input variables are close to equal. 
</p>
<p>
The two real input variables are <code>u1</code> and <code>u2</code>.
The allowed deviation is represented by the parameter <code>alwDev</code>. 
If <code>u1 &lt; u2 + alwDev</code> and <code>u1 &gt; 
u2 - alwDev</code>, then the output <code>yEuqFla</code> is <code>true</code>. 
Otherwise, the output <code>yEuqFla</code> is <code>false</code>. 
</p>
</html>",
        revisions="<html>
<ul>
<li>
April 03, 2026, by Weiping Huang:<br/>
First implementation.
</li>

</ul>
</html>"));
end RealEqual;
