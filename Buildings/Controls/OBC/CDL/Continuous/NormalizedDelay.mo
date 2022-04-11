within Buildings.Controls.OBC.CDL.Continuous;
block NormalizedDelay "Calculate a time delay based on a relay experiment"
  parameter Real gamma=3 "Asymmetry level of a relay tuner";
  Interfaces.RealInput dtON "Half-period length for the higher value"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}), iconTransformation(extent={{-140,40},{-100,80}})));
  Interfaces.RealInput dtOFF "Half-period length of the lower value"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}), iconTransformation(extent={{-140,-80},{-100,-40}})));
  Interfaces.RealOutput y "Normalized time delay"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  Max max annotation (Placement(transformation(extent={{-62,40},{-42,60}})));
  Min min annotation (Placement(transformation(extent={{-60,-64},{-40,-44}})));
  Divide rho "Half-period ratio" annotation (Placement(transformation(extent={{-16,-10},{4,10}})));
  Modelica.Blocks.Sources.RealExpression zeroCheck(y=noEvent(if min.y > 0 then min.y else 1))
    annotation (Placement(transformation(extent={{-58,-30},{-38,-10}})));
equation
  assert(abs(gamma-1)>0.01, "The relay signal should be asymmetric");
//  assert(rho.y>1, "The half-period ratio should be larger than 1");
//  assert(y>1 or y<0, "Invalid value for the normalized time delay");
  y=(gamma-rho.y)/(gamma-1)/(0.35*rho.y+0.65);
  connect(max.u1, dtON) annotation (Line(points={{-64,56},{-80,56},{-80,60},{-120,60}}, color={0,0,127}));
  connect(max.u2, dtOFF) annotation (Line(points={{-64,44},{-82,44},{-82,-60},{-120,-60}}, color={0,0,127}));
  connect(min.u1, dtON) annotation (Line(points={{-62,-48},{-92,-48},{-92,60},{-120,60}}, color={0,0,127}));
  connect(min.u2, dtOFF) annotation (Line(points={{-62,-60},{-120,-60}},                     color={0,0,127}));
  connect(rho.u1, max.y) annotation (Line(points={{-18,6},{-30,6},{-30,50},{-40,50}}, color={0,0,127}));
  connect(zeroCheck.y, rho.u2) annotation (Line(points={{-37,-20},{-30,-20},{-30,-6},{-18,-6}}, color={0,0,127}));
  annotation (
    defaultComponentName="ave",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
        Text(
          textColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name"),
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-8,16}},
          color={0,0,0}),
        Line(
          points={{-100,60}},
          color={0,0,0},
          thickness=1),
        Text(
          extent={{226,60},{106,10}},
          textColor={0,0,0},
          textString=DynamicSelect("",String(y,
            leftJustified=false,
            significantDigits=3)))}),
    Documentation(
      info="<html>
<p>Block that calculates the normalized time delay based on results of a relay experiment for PID tuning</p>
</html>",
      revisions="<html>
<ul>
<li>March 30, 2022, by Sen Huang:<br>First implementation. </li>
</ul>
</html>"));
end NormalizedDelay;
