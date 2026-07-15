within Buildings.Controls.OBC.DemandFlexibility.Generic;
block DoubleSwitch "Double switch"

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u2 "Input variable 2" annotation (Placement(
        transformation(extent={{-140,-20},{-100,20}}), iconTransformation(
          extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y1 "Output variable 1"
    annotation (Placement(transformation(extent={{100,30},{140,70}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u1 "Input variable 1" annotation (Placement(
        transformation(extent={{-140,40},{-100,80}}), iconTransformation(extent
          ={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u3 "Input variable 3" annotation (Placement(
        transformation(extent={{-140,-80},{-100,-40}}), iconTransformation(
          extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y2 "Output variable 2" annotation (Placement(
        transformation(extent={{100,-70},{140,-30}}), iconTransformation(extent
          ={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi2
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
equation
  connect(swi1.y, y1) annotation (Line(points={{42,30},{80,30},{80,50},{120,50}},
        color={0,0,127}));
  connect(swi2.y, y2) annotation (Line(points={{42,-30},{80,-30},{80,-50},{120,-50}},
        color={0,0,127}));
  connect(u2, swi1.u2) annotation (Line(points={{-120,0},{0,0},{0,30},{18,30}},
        color={255,0,255}));
  connect(u2, swi2.u2) annotation (Line(points={{-120,0},{0,0},{0,-30},{18,-30}},
        color={255,0,255}));
  connect(u1, swi1.u1) annotation (Line(points={{-120,60},{-80,60},{-80,38},{18,
          38}}, color={0,0,127}));
  connect(u3, swi1.u3) annotation (Line(points={{-120,-60},{-40,-60},{-40,22},{18,
          22}}, color={0,0,127}));
  connect(u1, swi2.u3) annotation (Line(points={{-120,60},{-80,60},{-80,-38},{18,
          -38}}, color={0,0,127}));
  connect(u3, swi2.u1) annotation (Line(points={{-120,-60},{-40,-60},{-40,-22},{
          18,-22}}, color={0,0,127}));
  annotation (defaultComponentName="setRes",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}},
    grid={2,2}), graphics={Rectangle(
      extent={{-100,100},{100,-100}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid), Text(
      extent={{-100,140},{100,100}},
      textColor={0,0,255},
          textString="%name")}), Diagram(
    coordinateSystem(preserveAspectRatio=false,
    grid={2,2})),
    Documentation(revisions="<html>
<ul>
<li>
June 10, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This block switches the values of the two real output variables based on a boolean
input variable.
</p>
<p>
If the input variable <code>u2</code> is <code>true</code>, the output variables
will be <code>y1 = u1</code> and <code>y2 = u3</code>. If the input variable
<code>u2</code> is <code>false</code>, the output variables will be
<code>y1 = u3</code> and <code>y2 = u1</code>.
</p>
</html>"));
end DoubleSwitch;
