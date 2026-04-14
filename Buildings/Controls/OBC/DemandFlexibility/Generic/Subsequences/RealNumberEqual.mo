within Buildings.Controls.OBC.DemandFlexibility.Generic.Subsequences;
block RealNumberEqual "Exact equal block for real numbers"
  parameter Real alwDev(min=1E-6)
    "Allowed deviation for equality";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u1 "Input real number 1"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u2 "Input real number 2"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEquFla "Equal flag"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  CDL.Reals.Add add "Input u2 plus allowed deviation"
    annotation (Placement(transformation(extent={{-30,16},{-10,36}})));
  CDL.Reals.Subtract                        sub
    "Input u2 minus allowed deviation"
    annotation (Placement(transformation(extent={{-30,-64},{-10,-44}})));
  CDL.Reals.Sources.Constant conAlwDev(k=alwDev) "Allowed deviation constant"
    annotation (Placement(transformation(extent={{-88,-16},{-68,4}})));
  CDL.Reals.Greater                        gre "Greater than"
    annotation (Placement(transformation(extent={{24,-56},{44,-36}})));
  CDL.Reals.Less                        les "Less than"
    annotation (Placement(transformation(extent={{22,24},{42,44}})));
  CDL.Logical.And                        and1
    "Input u1 within input u2 plus or minus allowed deviation"
    annotation (Placement(transformation(extent={{66,-12},{86,8}})));
equation
  connect(u2, add.u1) annotation (Line(points={{-120,-60},{-60,-60},{-60,32},{-32,
          32}}, color={0,0,127}));
  connect(u2,sub. u1) annotation (Line(points={{-120,-60},{-60,-60},{-60,-48},{-32,
          -48}}, color={0,0,127}));
  connect(conAlwDev.y, add.u2) annotation (Line(points={{-66,-6},{-42,-6},{-42,20},
          {-32,20}}, color={0,0,127}));
  connect(conAlwDev.y, sub.u2) annotation (Line(points={{-66,-6},{-42,-6},{-42,-60},
          {-32,-60}}, color={0,0,127}));
  connect(u1,les. u1) annotation (Line(points={{-120,60},{6,60},{6,34},{20,34}},
        color={0,0,127}));
  connect(u1,gre. u1) annotation (Line(points={{-120,60},{6,60},{6,-46},{22,-46}},
        color={0,0,127}));
  connect(add.y, les.u2)
    annotation (Line(points={{-8,26},{20,26}}, color={0,0,127}));
  connect(sub.y,gre. u2)
    annotation (Line(points={{-8,-54},{22,-54}},  color={0,0,127}));
  connect(les.y,and1. u1) annotation (Line(points={{44,34},{60,34},{60,-2},{64,-2}},
                                   color={255,0,255}));
  connect(gre.y,and1. u2) annotation (Line(points={{46,-46},{56,-46},{56,-10},{64,
          -10}},          color={255,0,255}));
  connect(and1.y, yEquFla) annotation (Line(points={{88,-2},{104,-2},{104,0},{120,
          0}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This block checks whether the values of 2 real input variables are equal to each other. </p>
<p>The 2 real input variables are <code>u1</code> and <code>u2</code>.
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
