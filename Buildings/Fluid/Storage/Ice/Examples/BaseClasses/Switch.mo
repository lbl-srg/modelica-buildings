within Buildings.Fluid.Storage.Ice.Examples.BaseClasses;
block Switch "Switch between three boolean signals using integer levels"
  Controls.OBC.CDL.Interfaces.BooleanInput u1 "Integer input signal"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Controls.OBC.CDL.Interfaces.BooleanInput u2 "Integer input signal"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Controls.OBC.CDL.Interfaces.BooleanInput y "Integer output signal"
    annotation (Placement(transformation(extent={{80,-20},{120,20}}),
        iconTransformation(extent={{80,-20},{120,20}})));

  Controls.OBC.CDL.Interfaces.BooleanInput u3 "Integer input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Controls.OBC.CDL.Interfaces.IntegerInput powLev "power level"
    annotation (Placement(transformation(extent={{-138,-80},{-98,-40}})));
equation
  if powLev == Integer(Buildings.Fluid.Storage.Ice.Examples.BaseClasses.OperationModes.LowPower) then
    y = u1;
  elseif powLev == Integer(Buildings.Fluid.Storage.Ice.Examples.BaseClasses.OperationModes.Efficiency) then
    y = u2;
  elseif powLev == Integer(Buildings.Fluid.Storage.Ice.Examples.BaseClasses.OperationModes.HighPower) then
    y = u3;
  else
    y = false;
  end if;
  annotation (
    defaultComponentName="intSwi",
    Documentation(
      info="<html>
<p>
Block that outputs one of two integer input signals based on a boolean input signal.
</p>
<p>
If the input signal <code>u2</code> is <code>true</code>,
the block outputs <code>y = u1</code>.
Otherwise, it outputs <code>y = u3</code>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
July 17, 2020, by Jianjun Hu:<br/>
Changed icon to display dynamically which input signal is being outputted.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2033\"># 2033</a>.
</li>
<li>
July 10, 2019, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          lineThickness=5.0,
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Line(
          points={{12,0},{100,0}},
          color={217,67,180}),
        Line(
          points={{-98,40},{-38,40},{-38,40}},
          color={217,67,180}),
        Line(
          points={{-98,80},{-38,80}},
          color={217,67,180}),
        Line(
          points=DynamicSelect({{8,2},{-40,80}},{{8,2},
            if u2 then
              {-40,80}
            else
              {-40,-80}}),
          color={217,67,180},
          thickness=1),
        Ellipse(
          lineColor={0,0,127},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{2.0,-6.0},{18.0,8.0}}),
        Text(
          extent={{-88,2},{-44,-24}},
          textColor={0,0,0},
          textString="hig"),
        Text(
          extent={{-92,42},{-40,12}},
          textColor={0,0,0},
          textString="eff"),
        Text(
          extent={{-150,150},{150,110}},
          textColor={0,0,255},
          textString="%name"),
        Line(
          points={{-98,-60},{-38,-60},{-38,-60}},
          color={244,125,35}),
        Line(
          points={{-96,0},{-36,0},{-36,0}},
          color={217,67,180}),
        Text(
          extent={{-92,82},{-40,52}},
          textColor={0,0,0},
          textString="low"),
        Text(
          extent={{-94,-54},{-42,-84}},
          textColor={0,0,0},
          textString="powLev")}));
end Switch;
