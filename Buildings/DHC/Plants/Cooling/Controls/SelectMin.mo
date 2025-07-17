within Buildings.DHC.Plants.Cooling.Controls;
block SelectMin
  "Block that includes or excludes storage plant pressure signal for min"

  parameter Integer nin
    "Number of input connections"
    annotation (Dialog(connectorSizing=true),HideResult=true);
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpUse[nin]
    "Connector of Real input signals"
    annotation (Placement(transformation(extent={{-140,50},{-100,90}}),
        iconTransformation(extent={{-140,80},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpStoPla
    "Connector of Real input signals"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,20},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput isChaRem
    "The storage plant is in remote charging mode"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Reals.MultiMin mulMin(nin=nin)
    "Find minimum value from the input vector"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Controls.OBC.CDL.Reals.Min min1 "Smaller input"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi "Switch between inputs"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

equation
  connect(dpUse, mulMin.u)
    annotation (Line(points={{-120,70},{-82,70}}, color={0,0,127}));
  connect(isChaRem, swi.u2) annotation (Line(points={{-120,-60},{0,-60},{0,0},{58,
          0}}, color={255,0,255}));
  connect(mulMin.y, min1.u1) annotation (Line(points={{-58,70},{-40,70},{-40,56},
          {-2,56}}, color={0,0,127}));
  connect(min1.y, swi.u1)
    annotation (Line(points={{22,50},{40,50},{40,8},{58,8}}, color={0,0,127}));
  connect(mulMin.y, swi.u3) annotation (Line(points={{-58,70},{-40,70},{-40,-8},
          {58,-8}}, color={0,0,127}));
  connect(dpStoPla, min1.u2) annotation (Line(points={{-120,0},{-60,0},{-60,44},
          {-2,44}}, color={0,0,127}));
  connect(swi.y, y) annotation (Line(points={{82,0},{120,0}}, color={0,0,127}));
annotation(defaultComponentName="selMin",
    Icon(graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
                   Line(
          points={{-80,60},{-60,40},{-20,80}},
          color={0,140,72},
          thickness=5), Text(
          extent={{-78,2},{-20,-78}},
          textColor={28,108,200},
          textString="?"),
        Text(
          textColor={0,0,255},
          extent={{-100,100},{100,140}},
          textString="%name")}),
    Documentation(info="<html>
<p>
This block finds the minimum value from pressure head signals.
The signal from the storage plant is included
only when the plant is in remote charging mode.
</p>
</html>", revisions="<html>
<ul>
<li>
February 6, 2025 by Jianjun Hu:<br/>
Reimplemented to comply CDL specification. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4110\">Buildings, #4110</a>.
</li>
<li>
Jun 23, 2023 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end SelectMin;
