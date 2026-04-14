within Buildings.Controls.OBC.DemandFlexibility.Generic.Subsequences;
block RealNumberEqual "Check whether two real numbers are close to equal"
  parameter Real alwDev(min=1E-6)
    "Allowed deviation for equality";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u1 "Input real number 1"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u2 "Input real number 2"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEquFla "Equal flag"
    annotation (Placement(transformation(extent={{100,-18},{140,22}})));
  Buildings.Controls.OBC.CDL.Reals.Add add "Input u2 plus allowed deviation"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract                        sub
    "Input u2 minus allowed deviation"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conAlwDev(k=alwDev) "Allowed deviation constant"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Buildings.Controls.OBC.CDL.Reals.Greater                        gre "Greater than"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Less                        les "Less than"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.Controls.OBC.CDL.Logical.And                        and1
    "Input u1 within input u2 plus or minus allowed deviation"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
equation
  connect(u2, add.u1) annotation (Line(points={{-120,-60},{-60,-60},{-60,36},{-42,
          36}}, color={0,0,127}));
  connect(u2,sub. u1) annotation (Line(points={{-120,-60},{-60,-60},{-60,-44},{-42,
          -44}}, color={0,0,127}));
  connect(conAlwDev.y, add.u2) annotation (Line(points={{-78,-10},{-50,-10},{-50,
          24},{-42,24}},
                     color={0,0,127}));
  connect(conAlwDev.y, sub.u2) annotation (Line(points={{-78,-10},{-50,-10},{-50,
          -56},{-42,-56}},
                      color={0,0,127}));
  connect(u1,les. u1) annotation (Line(points={{-120,60},{6,60},{6,30},{18,30}},
        color={0,0,127}));
  connect(u1,gre. u1) annotation (Line(points={{-120,60},{6,60},{6,-50},{18,-50}},
        color={0,0,127}));
  connect(add.y, les.u2)
    annotation (Line(points={{-18,30},{-8,30},{-8,22},{18,22}},
                                               color={0,0,127}));
  connect(sub.y,gre. u2)
    annotation (Line(points={{-18,-50},{0,-50},{0,-58},{18,-58}},
                                                  color={0,0,127}));
  connect(les.y,and1. u1) annotation (Line(points={{42,30},{50,30},{50,0},{58,0}},
                                   color={255,0,255}));
  connect(gre.y,and1. u2) annotation (Line(points={{42,-50},{50,-50},{50,-8},{58,
          -8}},           color={255,0,255}));
  connect(and1.y, yEquFla) annotation (Line(points={{82,0},{104,0},{104,2},{120,
          2}}, color={255,0,255}));
  annotation (defaultComponentName="reaNumEqu",
        Icon(coordinateSystem(preserveAspectRatio=false), graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-72,164},{76,104}},
          textColor={0,0,255},
          textString="%name")}),                           Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This block checks whether the values of two real input variables are close to equal. </p>
<p>The two real input variables are <code>u1</code> and <code>u2</code>.
The allowed deviation is represented by the parameter <code>alwDev</code>. 
If <code>u1 &lt; u2 + alwDev</code> and <code>u1 &gt; 
u2 - alwDev</code>, then the output <code>yEuqFla</code> is <code>true</code>. 
Otherwise, the output <code>yEuqFla</code> is <code>false</code>. </p>
</html>",
        revisions="<html>
<ul>
<li>
April 03, 2026, by Weiping Huang:<br/>
First implementation.
</li>

</ul>
</html>"));
end RealNumberEqual;
