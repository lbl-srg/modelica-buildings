within Buildings.Templates.Plants.Controls.HeatRecoveryChillers;
block AvailabilityStatus
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHeaCoo annotation (
      Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEnaCoo annotation (
      Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEnaHea annotation (
      Placement(transformation(extent={{-140,-60},{-100,-20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd(nin=3)
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd1(nin=3)
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(nin=3)
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput ySta annotation (
      Placement(transformation(extent={{100,-20},{140,20}}), iconTransformation(
          extent={{100,-20},{140,20}})));
equation
  connect(uEnaCoo, and2.u1) annotation (Line(points={{-120,0},{-90,0},{-90,-20},
          {-82,-20}}, color={255,0,255}));
  connect(uEnaHea, and2.u2) annotation (Line(points={{-120,-40},{-90,-40},{-90,
          -28},{-82,-28}}, color={255,0,255}));
  connect(uHeaCoo, not1.u) annotation (Line(points={{-120,40},{-92,40},{-92,60},
          {-82,60}}, color={255,0,255}));
  connect(uEnaCoo, not2.u) annotation (Line(points={{-120,0},{-90,0},{-90,20},{
          -82,20}}, color={255,0,255}));
  connect(uEnaHea, not3.u) annotation (Line(points={{-120,-40},{-90,-40},{-90,
          -60},{-82,-60}}, color={255,0,255}));
  connect(not1.y, mulAnd.u[1]) annotation (Line(points={{-58,60},{-30,60},{-30,
          38},{-28,38},{-28,37.6667},{-22,37.6667}}, color={255,0,255}));
  connect(not2.y, mulAnd.u[2]) annotation (Line(points={{-58,20},{-34,20},{-34,
          40},{-22,40}}, color={255,0,255}));
  connect(uEnaHea, mulAnd.u[3]) annotation (Line(points={{-120,-40},{-90,-40},{
          -90,-36},{-26,-36},{-26,42.3333},{-22,42.3333}}, color={255,0,255}));
  connect(not1.y, mulAnd1.u[1]) annotation (Line(points={{-58,60},{-30,60},{-30,
          -2.33333},{-22,-2.33333}}, color={255,0,255}));
  connect(uEnaCoo, mulAnd1.u[2]) annotation (Line(points={{-120,0},{-30,0},{-30,
          0},{-22,0}}, color={255,0,255}));
  connect(not3.y, mulAnd1.u[3]) annotation (Line(points={{-58,-60},{-36,-60},{
          -36,4},{-22,4},{-22,2.33333}}, color={255,0,255}));
  connect(mulAnd.y, mulOr.u[1]) annotation (Line(points={{2,40},{28,40},{28,
          -2.33333},{38,-2.33333}}, color={255,0,255}));
  connect(mulAnd1.y, mulOr.u[2])
    annotation (Line(points={{2,0},{28,0},{28,0},{38,0}}, color={255,0,255}));
  connect(and2.y, mulOr.u[3]) annotation (Line(points={{-58,-20},{24,-20},{24,0},
          {38,0},{38,2.33333}}, color={255,0,255}));
  connect(mulOr.y, ySta)
    annotation (Line(points={{62,0},{120,0}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
          preserveAspectRatio=false)));
end AvailabilityStatus;
